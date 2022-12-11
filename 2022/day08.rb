# --- Day 8: Treetop Tree House ---
# https://adventofcode.com/2022/day/8

class TreetopTreeHouse
  def self.part1
    input = ::File.read("./inputs/input08.txt").split("\n").map { |x| x.split("").map(&:to_i) }
    heightmap = Heightmap.new(input)
    heightmap.visible_points.count
  end

  def self.part2
    input = ::File.read("./inputs/input08.txt").split("\n").map { |x| x.split("").map(&:to_i) }
    heightmap = Heightmap.new(input)
    heightmap.scenic_scores.max
  end

  Point = Struct.new(:x, :y, :height)
  class Heightmap
    include Enumerable

    def initialize(input) = @points = input.map.with_index { |row, y| row.map.with_index { |height, x| Point.new(x, y, height) } }
    def each(&block) = @points.each { |row| row.each { |p| block&.call(p) } }
    def scenic_scores = map { |point| scenic_score(point) }
    def visible_points = select { |point| point.height > max_height(point) }

    def scenic_score(point, dir = nil, target_height = point.height)
      return scenic_score(point, :west) * scenic_score(point, :east) * scenic_score(point, :north) * scenic_score(point, :south) if !dir

      x, y = point.x, point.y
      case dir
      when :north
        y += 1
      when :south
        y -= 1
      when :west
        x -= 1
      when :east
        x += 1
      end

      next_point = point_at(x, y)
      return 0 if !next_point
      return 1 if next_point.height >= target_height
      1 + scenic_score(next_point, dir, target_height)
    end

    def max_height(point, dir = nil)
      return [max_height(point, :west), max_height(point, :east), max_height(point, :north), max_height(point, :south)].min if !dir

      x, y = point.x, point.y
      case dir
      when :north
        y += 1
      when :south
        y -= 1
      when :west
        x -= 1
      when :east
        x += 1
      end

      next_point = point_at(x, y)
      return -1 if !next_point
      [next_point.height, max_height(next_point, dir)].max
    end

    private

    def point_at(x, y)
      return if x < 0
      return if y < 0
      return if y >= @points.length
      return if x >= @points.first.length
      @points[y][x]
    end
  end
end

puts TreetopTreeHouse.part1
puts TreetopTreeHouse.part2
