class WorkerBee
  VERSION = '1.0.0'
  
  def initialize
    
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
