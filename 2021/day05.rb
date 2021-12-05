# --- Day 5: Hydrothermal Venture ---
# https://adventofcode.com/2021/day/5

class Integer
  def to(n)
    self > n ? downto(n) : upto(n)
  end
end

class HydrothermalVenture
  def initialize
    @lines = ::File.foreach("./inputs/input05.txt").map do |coordinates|
      Line.new(coordinates)
    end
  end

  def part1
    points = Points.new
    @lines.each do |line|
      line.for_each_point { |x,y| points.plot(x, y) }
    end
    points.overlapping_count
  end

  def part2
    points = Points.new
    @lines.each do |line|
      line.for_each_point(include_diagonal: true) { |x,y| points.plot(x, y) }
    end
    points.overlapping_count
  end

  private

  class Points < Hash
    def initialize
      super(0)
    end

    def plot(x, y)
      self[[x,y]] += 1
    end

    def overlapping_count
      values.count { |n| n > 1 }
    end
  end

  class Line
    def initialize(coordinates)
      /^(?<x1>\d+),(?<y1>\d+) -> (?<x2>\d+),(?<y2>\d+)$/ =~ coordinates

      @x1 = x1.to_i
      @x2 = x2.to_i
      @y1 = y1.to_i
      @y2 = y2.to_i
    end

    def for_each_point(include_diagonal: false)
      if @x1 == @x2 || @y1 == @y2
        @x1.to(@x2).each do |x|
          @y1.to(@y2).each do |y|
            yield [x,y]
          end
        end
      elsif include_diagonal
        @x1.to(@x2).zip(@y1.to(@y2)).each { |x,y| yield [x,y] }
      end
    end
  end
end

hydrothermal_venture = HydrothermalVenture.new
puts hydrothermal_venture.part1
puts hydrothermal_venture.part2
