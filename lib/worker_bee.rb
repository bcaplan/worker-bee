module WorkerBee
  VERSION = '1.0.0'
  class Task
    attr_reader   :name, :block
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
  
  @tasks = {}
  
  def self.tasks
    @tasks
  end

  def self.recipe &block
    raise(ArgumentError, "Block required") unless block_given?
    WorkerBee.module_eval(&block)
  end
  
  def self.task name, *deps, &block
    raise(ArgumentError, "Block required") unless block_given?
    @tasks[name.to_sym] = Task.new(name.to_sym, block, *deps)
  end
  
  def self.run task
    if @tasks.key? task.to_sym
      @tasks[task.to_sym].run
    else
      raise(ArgumentError, "#{task.to_s} is not a valid task")
    end
  end
end
