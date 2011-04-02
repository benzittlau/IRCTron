require "rubygems"
require "eventmachine"


n = 0
 timer = EventMachine::PeriodicTimer.new(5) do
   puts "the time is #{Time.now}"
   timer.cancel if (n+=1) > 5
 end

