require 'worker_bee'

WorkerBee.recipe do
  task :sammich, :meat, :bread do
    puts "** sammich!"
  end

  task :meat, :clean do
    puts "** meat"
  end

  task :bread, :clean do
    puts "** bread"
  end

  task :clean do
    sleep 5
    puts "** cleaning!"
  end
end

WorkerBee.run :sammich