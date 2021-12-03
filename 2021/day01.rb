# --- Day 1: Sonar Sweep ---
# https://adventofcode.com/2021/day/1

class SonarSweep
  def initialize
    @lines = ::File.read("./inputs/input01.txt").split.map(&:to_i)
  end

  def part1
    count_increasing_rows @lines
  end

  def part2
    count_increasing_rows @lines.each_cons(3).map { |group| group.reduce(&:+) }
  end

  private

  def count_increasing_rows(rows)
    rows.reduce([0,]) do |(sum, prev), curr|
      [prev && prev < curr ? sum + 1 : sum, curr]
    end.first
  end
end

sonar_sweep = SonarSweep.new
puts sonar_sweep.part1
# 1462
puts sonar_sweep.part2
# 1497
