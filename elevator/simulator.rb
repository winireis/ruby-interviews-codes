require 'csv'
require 'date'
require_relative 'passenger.rb'
require_relative 'elevator_balancer.rb'

def transformation
  csv = CSV.read("elevadores.csv")
  queue = []
  csv.each do |person|
    name = person[0]
    arrival = getTime(DateTime.parse(person[1]))
    destiny = person[2].to_i
    passenger = Passenger.new(name, arrival, destiny)
    queue.push passenger
  end
  return queue
end

def getTime(datetime)
  year = datetime.year
  month = datetime.mon
  day = datetime.mday
  hour = datetime.hour
  minute = datetime.min
  second = datetime.sec
  return Time.new(year, month, day, hour, minute, second)
end

number_of_elevators = 4
number_of_floors = 25
queue = transformation

balancer = ElevatorBalancer.new(number_of_elevators, number_of_floors, queue)
balancer.work
balancer.print_statistics
balancer.print_final_state
