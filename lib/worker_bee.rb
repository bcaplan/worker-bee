class WorkerBee
  VERSION = '1.0.0'
  
  attr_accessor :completed_tasks
  
  def initialize
    @completed_tasks = Hash.new
  end
  
  def self.recipe &block
    raise(ArgumentError, "Block required") unless block_given?
    block
  end
  
  def self.run symbol
    "running #{symbol.to_s}"
  end
  
  def task name, *deps, &block
    raise(ArgumentError, "Block required") unless block_given?
    block
  end
  
end
