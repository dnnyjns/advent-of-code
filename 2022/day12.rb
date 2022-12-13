# --- Day 12: Hill Climbing Algorithm ---
# https://adventofcode.com/2022/day/12

class HillClimbingAlgorithm
  LETTERS = ('a'..'z').to_a
  Point = Struct.new(:x, :y, :letter) do
    def can_visit?(other_point) = other_point.height - height < 2

    def height
      @height ||= begin
        case letter
        when "S"
          0
        when "E"
          25
        else
          LETTERS.index(letter)
        end
      end
    end
  end

  def self.points
    Points.new(::File.foreach("./inputs/input12.txt").
           map { |row| row.chomp.split('') }.
           map.
           with_index { |row, y| row.map.with_index { |letter, x| Point.new(x, y, letter) } })
  end

  def self.part1
    new(points).shortest_path_to(points.end_point).length
  end

  def self.part2
    Point.class_eval do
      def can_visit?(other_point) = height - other_point.height < 2
    end

    points = self.points
    heightmap = new(points, points.end_point)

    points.
      select { |point| point.letter == 'a' }.
      map { |point| heightmap.shortest_path_to(point) }.
      compact.
      map(&:length).
      min
  end

  class Points
    include Enumerable

    def initialize(points) = @points = points
    def each(&block) = @points.each { |row| row.each { |point| block&.call(point) } }
    def end_point = @end_point ||= detect { |point| point.letter == "E" }
    def at(x, y)
      return if x < 0
      return if y < 0
      return if y >= @points.length
      return if x >= @points.first.length
      @points[y][x]
    end
  end

  def initialize(points, starting_point = points.detect { |point| point.letter == "S" })
    @points = points
    @visited = []
    @edge_to = {}
    @starting_point = starting_point
    build_paths(@starting_point)
  end

  def can_visit?(point, other_point) = other_point.height - point.height < 2

  def shortest_path_to(point)
    return unless has_path_to?(point)
    path = []

    while(point != @starting_point) do
      path.unshift(point)
      point = @edge_to[point]
    end

    path
  end

  def has_path_to?(point)
    @visited.include?(point)
  end

  def build_paths(point)
    queue = []
    queue << point
    @visited << point

    while queue.any?
      current_point = queue.shift

      adjacent_points(current_point).each do |adjacent_point|
        next if @visited.include?(adjacent_point)
        queue << adjacent_point
        @visited << adjacent_point
        @edge_to[adjacent_point] = current_point
      end
    end
  end

  def adjacent_points(point)
    x = point.x
    y = point.y

    points = [@points.at(x+1, y), @points.at(x-1, y), @points.at(x, y-1), @points.at(x, y+1)]
    points.compact.select { |other_point| point.can_visit?(other_point) }
  end
end

puts HillClimbingAlgorithm.part1
puts HillClimbingAlgorithm.part2
