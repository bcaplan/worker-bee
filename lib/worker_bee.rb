module WorkerBee
  VERSION = '1.0.0'
  class Task
    attr_reader   :name
    attr_reader   :block
    attr_accessor :deps
    
    def initialize name, block, *deps
      @name     = name
      @block    = block
      @deps     = *deps
      @complete = false
    end
    
    def run
      @complete = true
      block.call
    end
    
    def complete?
      @complete
    end
  end
  
  @@tasks = {}
  
  def self.tasks
    @@tasks
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
end
