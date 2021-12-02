# --- Day 2: Dive! ---
# https://adventofcode.com/2021/day/2

class Dive
  def initialize
    @lines = ::File.read("./input.txt").split("\n")
  end

  def part1
    depth      = 0
    horizontal = 0

    @lines.each do |line|
      direction, units = line.split(" ")
      units = units.to_i
      case direction
      when "forward"
        horizontal += units
      when "down"
        depth += units
      when "up"
        depth -= units
      end
    end

    depth * horizontal
  end

  def part2
    aim        = 0
    depth      = 0
    horizontal = 0

    @lines.each do |line|
      direction, units = line.split(" ")
      units = units.to_i
      case direction
      when "forward"
        horizontal += units
        depth      += aim * units
      when "down"
        aim   += units
      when "up"
        aim   -= units
      end
    end

    depth * horizontal
  end
end

dive = Dive.new
puts dive.part1
# 2039912
puts dive.part2
# 1942068080
