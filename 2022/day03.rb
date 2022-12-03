# --- Day 3: Rucksack Reorganization ---
# https://adventofcode.com/2022/day/3

class RucksackReorganization
  VALUES = [*('a'..'z'), *('A'..'Z')]

  def self.part1
    ::File.read("./inputs/input03.txt").split("\n").map do |row|
      length = row.length
      first, second = row[0...length / 2], row[length / 2..-1]

      char = first.each_char.detect do |char|
        second.include?(char)
      end

      VALUES.find_index(char) + 1
    end.sum
  end

  def self.part2
    ::File.read("./inputs/input03.txt").split("\n").each_slice(3).map do |group|
      first, second, third = group
      char = first.each_char.detect do |char|
        second.include?(char) && third.include?(char)
      end

      VALUES.find_index(char) + 1
    end.sum
  end
end

puts RucksackReorganization.part1
puts RucksackReorganization.part2
