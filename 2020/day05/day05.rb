# --- Day 5: Binary Boarding ---
# https://adventofcode.com/2020/day/5

class BinaryBoarding
  class BoardingPass
    attr_reader :data

    def initialize(data)
      @data = data.strip
    end

    def to_s
      "#{data} - #{find_row} * 8 + #{find_column} = #{seat_id}"
    end

    def seat_id
      (find_row * 8) + find_column
    end

    def bsearch(value, lower_key:, upper_key:)
      lower = 0
      upper = 2 ** value.length - 1

      value.split("").each do |key|
        if key == lower_key
          upper = (upper - lower) / 2
          upper += lower
        elsif key == upper_key
          lower += ((upper - lower) / 2.0).ceil
        end
      end

      lower
    end

    def find_row
      bsearch(data[0..6], lower_key: "F", upper_key: "B")
    end

    def find_column
      bsearch(data[7..-1], lower_key: "L", upper_key: "R")
    end
  end

  attr_reader :boarding_passes

  def initialize
    @boarding_passes = ::File.foreach("./day05.txt").map do |data|
      BoardingPass.new(data)
    end
  end

  def part1
    @boarding_passes.max { |bp1, bp2| bp1.seat_id <=> bp2.seat_id }
  end

  def part2
    ordered = @boarding_passes.sort_by { |bp| bp.seat_id }
    prev_seat = ordered.detect.with_index do |bp, index|
      ordered[index+1].seat_id == bp.seat_id + 2
    end

    prev_seat.seat_id + 1
  end
end

bb = BinaryBoarding.new
puts "--- Day 5: Binary Boarding ---"
puts "Part 1: #{bb.part1}"
puts "Part 2: #{bb.part2}"
