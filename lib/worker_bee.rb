module WorkerBee
  VERSION = '1.0.0'
  
  @@tasks = {}
  @@completed_tasks = {}
  
  def self.tasks
    @@tasks
  end
  
  def self.completed_tasks
    @@completed_tasks
  end

  def self.recipe &block
    raise(ArgumentError, "Block required") unless block_given?
    block
  end
  
  def self.task name, *deps, &block
    raise(ArgumentError, "Block required") unless block_given?
    block
  end
  
  def self.run symbol
    "running #{symbol.to_s}"
  end
  
  class Task
    
  end

end
