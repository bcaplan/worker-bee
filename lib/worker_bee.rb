module WorkerBee
  VERSION = '1.0.0'
  class Task
    attr_reader   :name, :block
    attr_accessor :deps
    
    def initialize name, block, *deps
      @name     = name
      @block    = block
      @deps     = deps
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
  
  def self.run task, level = -1
    task = task.to_sym
    if @tasks.key? task
      puts "#{"  " * (level += 1)}running #{task.to_s}"
      until @tasks[task].deps.empty?
        if @tasks[@tasks[task].deps.first].complete?
          puts "#{"  " * (level + 1)}not running #{@tasks[task].deps.shift.to_s} - already met dependency"
        else
          WorkerBee.run @tasks[task].deps.shift, level
        end
      end
      @tasks[task].run
    else
      raise(ArgumentError, "#{task.to_s} is not a valid task")
    end
  end
end
