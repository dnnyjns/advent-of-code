# --- Day 11: Dumbo Octopus ---
# https://adventofcode.com/2021/day/11

class DumboOctopus
  def part1
    oct = Octopuses.new
    100.times.map do
      oct.step
      oct.count(&:flashed?)
    end.sum
  end

  def part2
    oct = Octopuses.new
    steps = 0
    while !oct.all?(&:flashed?)
      oct.step
      steps += 1
    end
    steps
  end

  class Octopuses
    Oct = Struct.new(:x, :y, :energy) do
      def step
        return if flashed?
        if energy == 9
          @flashed = true
          self.energy = 0
        else
          self.energy += 1
        end
      end

      def flashed?
        @flashed
      end

      def flashed_adjacent?
        @flash_adjacent
      end

      def flash_adjacent!
        @flash_adjacent = true
      end

      def reset!
        @flashed = false
        @flash_adjacent = false
      end
    end

    include Enumerable

    def initialize
      @octs = ::File.read("./inputs/input11.txt").split("\n").map.with_index { |row, y| row.chars.map.with_index { |oct,x| Oct.new(x,y,oct.to_i) }}
    end

    def step
      each(&:reset!).each(&:step).select(&:flashed?).each { |oct| flash_adjacent(oct) }
    end

    def each(&block)
      @octs.each do |row|
        row.each(&block)
      end
      self
    end

    private

    def flash_adjacent(oct)
      return if oct.flashed_adjacent?
      oct.flash_adjacent!
      adjacent_oct(oct).each(&:step).select(&:flashed?).each { |oct| flash_adjacent(oct) }
    end

    def adjacent_oct(oct)
      x = oct.x
      y = oct.y
      [
        oct_at(x+1, y), oct_at(x-1, y), oct_at(x, y-1), oct_at(x, y+1),
        oct_at(x+1, y-1), oct_at(x-1, y+1), oct_at(x-1, y-1), oct_at(x+1, y+1),
      ].reject(&:nil?)
    end

    def oct_at(x, y)
      return if x < 0
      return if y < 0
      return if y >= @octs.length
      return if x >= @octs.first.length
      @octs[y][x]
    end
  end
end

dumbo = DumboOctopus.new
puts dumbo.part1
puts dumbo.part2
