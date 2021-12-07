# --- Day 7: The Treachery of Whales ---
# https://adventofcode.com/2021/day/7

class TheTreacheryOfWhales
  def initialize
    @input = ::File.read("./inputs/input07.txt").split(",").map(&:to_i)
  end

  def part1
    (@input.min..@input.max).map { |x| fuel_cost(x) }.min
  end

  def part2
    (@input.min..@input.max).map { |x| fuel_cost2(x) }.min
  end

  private

  def fuel_cost(index)
    @input.map { |x| (x - index).abs }.reduce(&:+)
  end

  def fuel_cost2(index)
    @input.map do |x|
      n = (x - index).abs

      n*(n+1)/2
    end.reduce(&:+)
  end
end

whales = TheTreacheryOfWhales.new
puts whales.part1
puts whales.part2
