module WorkerBee
  VERSION = '1.0.0'
  class Task
    attr_reader   :block, :deps
    
    def initialize block, *deps
      @block    = block
      @deps     = deps
      @complete = false
    end
    
    def run
      out = block.call
      @complete = true
      out
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
    @tasks[name.to_sym] = Task.new(block, *deps)
  end
  
  def self.run task, level = -1
    task = task.to_sym
    raise(ArgumentError, "#{task.to_s} is not a valid task") unless @tasks.key? task
    puts "#{"  " * (level += 1)}running #{task.to_s}"
    @tasks[task].deps.each do |current_task|
      if @tasks[current_task].complete?
        puts "#{"  " * (level + 1)}not running #{current_task.to_s} - already met dependency"
      else
        WorkerBee.run current_task, level
      end
    end
    @tasks[task].run
  end
end
