require "test/unit"
require "worker_bee"

class TestWorkerBee < Test::Unit::TestCase
  def setup
     @wb = WorkerBee
     @output = StringIO.new
     $stdout = @output
  end
  
  def teardown
    $stdout = STDOUT
  end
  
  def test_recipe_evals_a_block
    actual = @wb.recipe do
      'hello'
    end
    
    assert_equal 'hello', actual
  end
  
  def test_recipe_raises_if_no_block
    assert_raise(ArgumentError) do
      @wb.recipe
    end
  end
  
  def test_recipe_scopes_block
    assert_nothing_raised(NoMethodError) do
      @wb.recipe do
        task :clean do
          'cleaned'
        end
      end
    end
  end
  
  def test_task_takes_many_arguments
    assert_nothing_raised(ArgumentError) do
      @wb.task :one, :two, :three, :four do
        'hello'
      end
    end
  end
  
  def test_task_raises_if_no_block
    assert_raise(ArgumentError) do
      @wb.task
    end
  end
    
  def test_task_adds_task_to_tasks
    @wb.task :clean do
      'cleaned'
    end
    
    assert @wb.tasks.key?(:clean)
  end
  
  def test_task_must_be_valid
    assert_raise(ArgumentError) do
      @wb.run :foo
    end
  end
 
  def test_task_gets_run
    @wb.recipe do
      task :clean do
        'cleaned'
      end
    end
    
    assert_equal 'cleaned', @wb.run(:clean)
  end
  
  def test_task_wont_run_until_deps_met
    @wb.recipe do
      task :glean do
        'gleaned'
      end
      
      task :done, :glean do
        'done!' if WorkerBee.tasks[:glean].complete?
      end
    end
    assert_equal 'done!', @wb.run(:done)
  end
  
  def test_task_wont_run_twice
    WorkerBee.module_eval("@glean_ran = 0")
    @wb.recipe do
      task :glean do
        @glean_ran += 1
      end
      
      task :middle, :glean do
        'middle'
      end
      
      task :done, :middle, :glean do
        'done!'
      end
    end
    @wb.run(:done)
    assert_equal 1, @wb.module_eval("@glean_ran")
  end
  
  
  ### Tests for Task class ###
  
  def test_task_obj_runs_block
    task = @wb::Task.new(:hello, Proc.new { 'hello' })
    
    assert_equal 'hello', task.run
  end
  
  def test_task_completes_when_run
    task = @wb::Task.new(:hello, Proc.new { 'hello' })
    assert ! task.complete?
    
    task.run
    
    assert task.complete?
  end
end
