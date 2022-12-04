# --- Day 4: Camp Cleanup ---
# https://adventofcode.com/2022/day/4

class CampCleanup
  def self.ranges
    ::File.read("./inputs/input04.txt").split("\n").map do |row|
      row.scan(/(\d+)-(\d+)/).map do |a, b|
        a.to_i..b.to_i
      end
    end
  end

  def self.part1
    ranges.count do |a, b|
      a.cover?(b) || b.cover?(a)
    end
  end

  def self.part2
    ranges.count do |a, b|
      a.begin <= b.end && b.begin <= a.end
    end
  end
end

puts CampCleanup.part1
puts CampCleanup.part2
