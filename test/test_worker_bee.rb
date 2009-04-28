require "test/unit"
require "worker_bee"

class TestWorkerBee < Test::Unit::TestCase
  def setup
     @wb = WorkerBee
  end
  
  def test_recipe_stores_a_block
    expected = 'hello'
    actual = @wb.recipe do
      'hello'
    end    
    
    assert_equal expected, actual.call
  end
  
  def test_recipe_raises_if_no_block
    assert_raise(ArgumentError) do
      @wb.recipe
    end
  end
  
  def test_task_stores_a_block    
    expected = 'hello'
    actual = @wb.task :name do
      'hello'
    end
    
    assert_equal expected, actual.call
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
  
  def test_run_takes_a_task
    expected = "running a_task"
    actual = WorkerBee.run :a_task
    
    assert_equal expected, actual
  end
    
  def test_completed_tasks_returns_nil_if_task_not_done
    assert_nil @wb.completed_tasks[:one]
  end

  # def test_task_gets_run
  #   WorkerBee.recipe do
  #     task :clean do
  #       'cleaned'
  #     end
  #   end
  #   
  #   assert_equal 'running clean\ncleaned', WorkerBee.run(:clean)
  # end

  # def test_task_assigns_name_to_first_arg
  #   expected = { :name => :coffee }
  #   actual = @wb.task :coffee do
  #     'i haz coffee'
  #   end
  #   
  #   assert_equal expected, actual
  # end
  
  ### Tests for Task class ###
  
  def test_task_obj_runs_block
    task = @wb::Task.new(Proc.new { 'hello' })
    
    assert_equal 'hello', task.call
  end
  
end
