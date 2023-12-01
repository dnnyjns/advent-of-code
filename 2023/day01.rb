# --- Day 1: Trebuchet?! ---
# https://adventofcode.com/2023/day/1

class Trebuchet
  def self.rows
    ::File.read("./inputs/input01.txt").split("\n")
  end

  def self.part1
    calibration_values = rows.map do |row|
      numbers = row.scan(/\d/)
      (numbers.first + numbers.last).to_i
    end

    calibration_values.sum
  end

  def self.part2
    calibration_values = rows.map do |row|
      numbers = row.scan(/(?=(one|two|three|four|five|six|seven|eight|nine|\d))/).flatten
      (calibration_value_part2(numbers.first) + calibration_value_part2(numbers.last)).to_i
    end

    calibration_values.sum
  end

  def self.calibration_value_part2(value)
    if /\d/.match?(value)
      value
    else
      case value
      when "one" then "1"
      when "two" then "2"
      when "three" then "3"
      when "four" then "4"
      when "five" then "5"
      when "six" then "6"
      when "seven" then "7"
      when "eight" then "8"
      when "nine" then "9"
      else raise "Unknown value: #{value}"
      end
    end
  end
end

puts Trebuchet.part1
puts Trebuchet.part2
