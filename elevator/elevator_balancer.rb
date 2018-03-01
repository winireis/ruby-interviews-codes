require_relative 'passenger.rb'
require_relative 'elevator.rb'

class ElevatorBalancer
  def initialize(number_of_elevators, number_of_floors, queue)
    @elevators = []
    @floors = {}
    @queue = queue
    @start_time = queue.first.arrival_time
    @current_time = @start_time
    number_of_elevators.times do
      @elevators.push Elevator.new(@start_time)
    end
    number_of_floors.times do |n|
      @floors[n+1] = []
    end
  end

  def work
    waiting_counter = 0
    boarding_counter = 0
    landing_counter = 0
    shipping_list = []

    while landing_counter < 1000
      while is_anybody_here?
        passenger = @queue.shift
        shipping_list.push passenger
        waiting_counter += 1
      end

      available_elevators_list = available_elevators
      if !available_elevators_list.empty?
        if !shipping_list.empty?
          passenger = shipping_list.shift
          elevator_number = best_choice(passenger, available_elevators_list)
          @elevators[elevator_number].ship(passenger, @current_time)
          boarding_counter += 1
        end
      end

      leaving_elevators = ready_to_go
      if !leaving_elevators.empty?
        leaving_elevators.each do |i|
          @elevators[i].travel(@current_time)
          passengers_list = @elevators[i].passengers_list
          passengers_list.each do |p|
            @floors[p.destiny_floor].push p
            landing_counter += 1
          end
          @elevators[i].reset
        end
      end
      tic
    end
  end

  def print_statistics
    waiting_time_list = []
    travel_time_list = []
    total_time_list = []
    @floors.each_pair do |f, pl|
      pl.each do |p|
        waiting_time_list.push p.waiting_time
        travel_time_list.push p.travel_time
        total_time_list.push p.total_time
      end
    end
    average_waiting_time = waiting_time_list.reduce(:+)/waiting_time_list.size
    average_travel_time = travel_time_list.reduce(:+)/travel_time_list.size
    average_total_time = total_time_list.reduce(:+)/total_time_list.size
    puts "Average waiting time: #{seconds_to_minutes(average_waiting_time)}"
    puts "Average travel time: #{seconds_to_minutes(average_travel_time)}"
    puts "Average total time: #{seconds_to_minutes(average_total_time)}"
  end

  def print_final_state
    @floors.each_pair do |f, pl|
      puts "Current floor: #{f}"
      pl.each do |p|
        puts "--#{p.name}"
        puts "----Waiting time: #{seconds_to_minutes(p.waiting_time)}"
        puts "----Travel time: #{seconds_to_minutes(p.travel_time)}"
        puts "----Total time: #{seconds_to_minutes(p.total_time)}"
      end
    end
  end

private
  def is_anybody_here?
    passenger = @queue.first
    return (!passenger.nil? && (passenger.arrival_time <= @current_time))
  end

  def available_elevators
    elevators_list = []
    @elevators.each do |v|
      if (v.departure_at.nil?) && (v.available_at <= @current_time)
        elevators_list.push @elevators.index(v)
      elsif (v.available_at <= @current_time) && (v.departure_at >= @current_time) && (v.passengers_list.size < 8)
        elevators_list.push @elevators.index(v)
      end
    end
    return elevators_list
  end

  def best_choice(passenger, elevators_list)
    elevators_list.each do |e|
      if @elevators[e].stops_list.include?(passenger.destiny_floor)
        return e
      end
    end
    elevators_list.each do |e|
      if @elevators[e].stops_list.empty?
        return e
      end
    end
    stops_counter = {}
    elevators_list.each do |e|
      stops_counter[e] = @elevators[e].stops_list.size
    end
    return stops_counter.key(stops_counter.values.min)
  end

  def ready_to_go
    elevators_list = []
    @elevators.each_with_index do |v, k|
      if v.departure_at == @current_time
        elevators_list.push k
      end
    end
    return elevators_list
  end

  def seconds_to_minutes(s)
    Time.at(s).strftime "%Mmin%Ss"
  end

  def tic
    @current_time += 1
  end
end
