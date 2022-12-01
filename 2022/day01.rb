# --- Day 1: Calorie Counting ---
# https://adventofcode.com/2022/day/1

class CalorieCounting
  def self.calories
    ::File.read("./inputs/input01.txt").split("\n\n").map { |row| row.split.map(&:to_i).sum }
  end

  def self.part1
    calories.max
  end

  def self.part2
    calories.max(3).sum
  end
end

puts CalorieCounting.part1
puts CalorieCounting.part2
