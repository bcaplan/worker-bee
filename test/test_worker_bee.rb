require "test/unit"
require "worker_bee"

class TestWorkerBee < Test::Unit::TestCase
  def setup
     @wb = WorkerBee.new
  end
  
  def test_recipe_stores_a_block
    expected = 'hello'
    actual = WorkerBee.recipe do
      'hello'
    end    
    
    assert_equal expected, actual.call
  end
  
  def test_task_stores_a_block    
    expected = 'hello'
    actual = @wb.task do
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
  
  def test_task_assigns_block_to_first_arg
    expected = { :name => :coffee }
    actual = @wb.task :coffee do
      'i haz coffee'
    end
    
    assert_equal expected, actual
  end
  
end
