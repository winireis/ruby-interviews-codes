require_relative 'passenger.rb'

class Elevator
  attr_accessor :available_at, :departure_at, :passengers_list, :stops_list
  def initialize(start)
    @available_at = start
    @departure_at = nil
    @passengers_list = []
    @stops_list = []
  end

  def ship(passenger, current_time)
    passenger.boarding_time = current_time
    if @passengers_list.empty?
      @departure_at = current_time + 20
    end
    @passengers_list.push passenger
    @stops_list.push passenger.destiny_floor
    @stops_list.uniq!
    @stops_list.sort!
  end

  def travel(current_time)
    @passengers_list.each do |p|
      stops_counter = @stops_list.index(p.destiny_floor)
      p.landing_time = current_time + (2*p.destiny_floor) + (20*stops_counter)
    end
  end

  def reset
    @available_at = @departure_at + (20 * @stops_list.size) + (4 * @stops_list.last)
    @departure_at = nil
    @stops_list = []
    @passengers_list = []
  end
end
