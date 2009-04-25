class WorkerBee
  VERSION = '1.0.0'
  
  def initialize
    
  end
  
  def self.recipe &block
    block
  end
  
  def self.run
    
  end
  
  def task *tasks, &block
    block
  end
  
end
