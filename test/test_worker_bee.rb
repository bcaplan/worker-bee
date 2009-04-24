require "test/unit"
require "worker_bee"

class TestWorkerBee < Test::Unit::TestCase
  def setup
     wb = WorkerBee.new
  end
  
  def test_recipe_takes_a_block
    expected = 'hello'
    actual = WorkerBee.recipe do
      'hello'
    end    
    
    assert_equal expected, actual
  end
  
  def test_task_takes_a_block    
    expected = 'hello'
    actual = wb.task do
      'hello'
    end
    
    assert_equal expected, actual
  end
  
  def test_task_takes_many_arguments
    assert_nothing_raised(ArgumentError) do
      WorkerBee.new.task :one, :two, :three, :four do
        'hello'
      end
    end
  end
  
end
