require 'json'

class AirplaneSeating

  def initialize(seats_array, passengers_count)
    @seats_array = JSON.parse(seats_array)
    @passengers_count = passengers_count.to_i
    @allocated_seats_count = 0
    @seats_arrangement_array = []
  end

  def arrange_seats
    higest_column_length = @seats_array.map(&:last).max
    @total_seats = @seats_array.each_with_object([]) do |a, s|
      s << (1..a[1]).map { |x| Array.new(a[0]) }
    end
    @arranged_seats = []
    (1..higest_column_length).each_with_object([]).with_index do |x, index|
      @arranged_seats << @total_seats.map { |x| x[index] }
    end
    arrang_asile_seats
    arrang_window_seats
    arrang_center_seats
  end

  private

  def arrang_asile_seats
    @arranged_seats.each_with_index do |a, index|
      reserved_array = []
      a.each_with_index do |arr, index|
        unless arr.nil?
          if index == 0 && @allocated_seats_count <= @passengers_count - 1
            arr[-1] = @allocated_seats_count+=1
            reserved_array << arr
          elsif index < a.length - 1 && @allocated_seats_count <= @passengers_count - 1
            arr[0] = @allocated_seats_count+=1
            arr[-1] = @allocated_seats_count+=1
            reserved_array << arr
          elsif @allocated_seats_count <= @passengers_count - 1
            arr[0] = @allocated_seats_count+=1
            reserved_array << arr 
          end
        end
      end
      @seats_arrangement_array << reserved_array 
    end
  end

  def arrang_window_seats
    @window_seats_array = []
    @seats_arrangement_array.each do |a|
      reserved_array = []
      a.each_with_index do |arr, index|
        unless arr.nil?
          if index == 0 && @allocated_seats_count <= @passengers_count - 1
            arr[0] = @allocated_seats_count+=1
            reserved_array << arr
          elsif index == a.length - 1 && @allocated_seats_count <= @passengers_count - 1
            arr[-1] = @allocated_seats_count+=1
            reserved_array << arr
          else
            reserved_array << arr
          end
        end
      end
      @window_seats_array << reserved_array
    end
  end

  def arrang_center_seats
    @center_seats = []
    @window_seats_array.each do |a|
      reserved_array = []
      a.each_with_index do |arr|
        unless arr.nil?
          if arr.length > 2
            (1..arr.length-2).each { |i| arr[i] = @allocated_seats_count+=1 if @allocated_seats_count <= @passengers_count - 1 }
          end
          reserved_array << arr
        end
      end
      @center_seats << reserved_array
    end
    @center_seats
  end
end

puts "Input an array that represents rows and colomuns"
seats_array = gets.chomp
puts "Number of passengers to board"
passengers_count = gets.chomp
airplane_seating = AirplaneSeating.new(seats_array, passengers_count)
File.open("output_file.txt", "w") do |file|
  airplane_seating.arrange_seats.each do |arr|
    file << arr.to_s + "\n"
  end
end


