# --- Day 6: Lanternfish ---
# https://adventofcode.com/2021/day/6

class Lanternfish
  def initialize
    @input = ::File.read("./inputs/input06.txt").split(",").map(&:to_i)
  end

  def part1
    simulate_cycles(@input, 80)
  end

  def part2
    simulate_cycles(@input, 256)
  end

  private

  def simulate_cycles(school_of_fish, days)
    days.times.reduce(school_of_fish.tally) { |f| count_fish(f) }.values.reduce(&:+)
  end

  def count_fish(school_of_fish)
    school_of_fish.reduce(Hash.new(0)) do |h, (day, count)|
      if day == 0
        h[6] += count
        h[8] += count
      else
        h[day-1] += count
      end

      h
    end
  end
end

lantern_fish = Lanternfish.new
puts lantern_fish.part1
puts lantern_fish.part2
