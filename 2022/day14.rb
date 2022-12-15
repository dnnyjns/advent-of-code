# --- Day 14: Regolith Reservoir ---
# https://adventofcode.com/2022/day/14

class RegolithReservoir
  def self.part1
    drop_sand
  end

  def self.part2
    drop_sand(with_floor: true) + 1
  end

  def self.drop_sand(with_floor: false)
    lines = ::File.foreach("./inputs/input14.txt").flat_map do |coordinates|
      coordinates.chomp.split(" -> ").each_cons(2).to_a
    end.map do |left, right|
      Line.new(*left.split(",").map(&:to_i), *right.split(",").map(&:to_i))
    end
    new(lines, with_floor: with_floor).drop_all_sand
  end

  class SandRested < StandardError; end
  def initialize(lines, with_floor: false)
    @with_floor = with_floor
    @points = Points.new
    lines.each do |line|
      line.each_point { |x,y| @points.plot(x, y) }
    end
  end

  def floor
    @floor ||= Line.new(-Float::INFINITY, @points.max_y + 2, Float::INFINITY, @points.max_y + 2)
  end

  def max_y
    @with_floor ? floor.max_y : @points.max_y
  end

  def fall_to?(x, y)
    !((@with_floor && floor.at?(x, y)) || @points.at?(x, y))
  end

  def drop_all_sand
    count = 0
    while drop_sand
      count += 1
    end

    count
  end

  def drop_sand
    coord = [500, 0]
    while coord
      begin
        coord = next_position(coord[0], coord[1])
        break if coord[1] > max_y
      rescue SandRested
        break
      end
    end
    return if coord[1] > max_y
    return if coord[0] == 500 && coord[1] == 0

    @points.plot(coord[0], coord[1])
    coord
  end

  def next_position(x, y)
    if fall_to?(x, y + 1)
      return x, y + 1
    elsif fall_to?(x - 1, y + 1)
      return x - 1, y + 1
    elsif fall_to?(x + 1, y + 1)
      return x + 1, y + 1
    else
      raise SandRested
    end
  end

  class Points < Hash
    def initialize
      super(0)
    end

    def max_y
      @max_y ||= keys.map(&:last).max
    end

    def at?(x, y)
      self[[x,y]] > 0
    end

    def plot(x, y)
      self[[x,y]] += 1
    end
  end

  class Line
    def initialize(x1, y1, x2, y2)
      @x1, @x2 = [x1, x2].minmax
      @y1, @y2 = [y1, y2].minmax
    end

    def max_y
      @max_y ||= [@y1, @y2].max
    end

    def at?(x, y)
      x_range.cover?(x) && y_range.cover?(y)
    end

    def x_range
      @x_range ||= (@x1..@x2)
    end

    def y_range
      @y_range ||= (@y1..@y2)
    end

    def each_point
      x_range.each do |x|
        y_range.each do |y|
          yield [x,y]
        end
      end
    end
  end
end

puts RegolithReservoir.part1
puts RegolithReservoir.part2
