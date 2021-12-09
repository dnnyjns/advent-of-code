# --- Day 9: Smoke Basin ---
# https://adventofcode.com/2021/day/9

class SmokeBasin
  def initialize
    input = ::File.read("./inputs/input09.txt").split("\n").map { |x| x.split("").map(&:to_i) }
    @heightmap = Heightmap.new(input)
  end

  def part1
    @heightmap.low_points.reduce(0) { |sum, point| sum + point.height + 1 }
  end

  def part2
    @heightmap.low_points.map { |point| @heightmap.basin(point) }.map(&:count).max(3).reduce(&:*)
  end

  class Heightmap
    def initialize(input)
      @points = input.map.with_index { |row, y| row.map.with_index { |height, x| Point.new(x, y, height) } }
    end

    def for_each_point
      Enumerator.new do |y|
        @points.each { |row| row.each { |p| y << p } }
      end
    end

    def low_points
      for_each_point.select { |point| is_low_point?(point) }
    end

    def basin(point, current_basin = [])
      return [] if current_basin.include?(point)
      current_basin.push(point)
      return [] if point.height == 9

      adjacent_points(point).reduce([point]) do |b, p|
        b + basin(p, current_basin)
      end
    end

    private

    def adjacent_points(point)
      x = point.x
      y = point.y
      [point_at(x+1, y), point_at(x-1, y), point_at(x, y-1), point_at(x, y+1)].reject(&:nil?)
    end

    def is_low_point?(point)
      point.height < adjacent_points(point).map(&:height).min
    end

    def point_at(x, y)
      return if x < 0
      return if y < 0
      return if y >= @points.length
      return if x >= @points.first.length
      @points[y][x]
    end
  end

  Point = Struct.new(:x, :y, :height)
end

aoc = SmokeBasin.new
puts aoc.part1
puts aoc.part2
