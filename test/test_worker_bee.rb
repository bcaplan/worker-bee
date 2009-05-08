require "test/unit"
require "worker_bee"

class TestWorkerBee < Test::Unit::TestCase
  def setup
    @output = StringIO.new
    $stdout = @output
  end

  def test_recipe_evals_a_block
    actual = WorkerBee.recipe do
      'hello'
    end

    assert_equal 'hello', actual
  end

  def test_recipe_scopes_block_and_adds_task
    WorkerBee.recipe do
      task :clean do
        'cleaned'
      end
    end

    assert WorkerBee.module_eval("@@tasks.key? :clean")
  end

  def test_task_stores_deps
    WorkerBee.task :one, :two, :three, :four do
      'hello'
    end

    assert_equal [ :two, :three, :four ], WorkerBee.module_eval("@@tasks[:one].deps")
  end

  def test_task_raises_if_no_block
    assert_raise(ArgumentError) do
      WorkerBee.task
    end
  end

  def test_task_adds_task_to_tasks
    WorkerBee.task :clean do
      'cleaned'
    end

    assert WorkerBee.tasks.key?(:clean)
  end

  def test_task_must_be_valid
    assert_raise(ArgumentError) do
      WorkerBee.run :foo
    end
  end

  def test_run_runs_specified_task
    WorkerBee.recipe do
      task :shouldnt_run do
        'I should not run'
      end

      task :clean do
        'cleaned'
      end
    end

    assert_equal 'cleaned', WorkerBee.run(:clean)
  end

  def test_task_wont_run_until_deps_met
    WorkerBee.recipe do
      task :glean do
        'gleaned'
      end

      task :done, :glean do
        'done!' if WorkerBee.tasks[:glean].complete?
      end
    end
    assert_equal 'done!', WorkerBee.run(:done)
  end

  def test_deps_run_in_correct_order
    check_order = []
    WorkerBee.recipe do
      task :two, :three do
        check_order << 'two'
      end

      task :one, :two, :three do
        check_order << 'one'
      end

      task :three do
        check_order << 'three'
      end
    end

    WorkerBee.run :one
    assert_equal ['three', 'two', 'one'], check_order
  end

  def test_task_wont_run_twice
    glean_ran = 0
    WorkerBee.recipe do
      task :glean do
        glean_ran += 1
      end

      task :middle, :glean do
        'middle'
      end

      task :done, :middle, :glean do
        'done!'
      end
    end
    WorkerBee.run(:done)

    assert_equal 1, glean_ran
  end


  ### Tests for Task class ###

  def test_task_obj_runs_block
    task = WorkerBee::Task.new(Proc.new { 'hello' })

    assert_equal 'hello', task.run
  end

  def test_task_completes_when_run
    task = WorkerBee::Task.new(Proc.new { 'hello' })
    assert ! task.complete?

    task.run

    assert task.complete?
  end
end
