class Passenger
  attr_reader :arrival_time, :name, :destiny_floor
  attr_accessor :boarding_time, :landing_time

  def initialize(name, arrival, floor)
    @name = name
    @destiny_floor = floor
    @arrival_time = arrival    
    @boarding_time = 0
    @landing_time = 0
  end

  def waiting_time
  	@boarding_time - @arrival_time
  end

  def travel_time
  	@landing_time - @boarding_time
  end

  def total_time
  	@landing_time - @arrival_time
  end
end
