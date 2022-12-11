# --- Day 9: Rope Bridge ---
# https://adventofcode.com/2022/day/9

class RopeBridge
  Point = Struct.new(:x, :y) do
    attr_accessor :tail, :visited

    def initialize(...)
      super
      @visited ||= [dup]
    end

    def find_tail
      return self unless tail
      tail.find_tail
    end

    def adjust(head_x, head_y)
      dist_x = head_x - x
      dist_y = head_y - y
      if dist_x.abs == 2 && dist_y == 0
        self.x += dist_x.positive? ? 1 : -1
      elsif dist_y.abs == 2 && dist_x == 0
        self.y += dist_y.positive? ? 1 : -1
      elsif (dist_y.abs == 2 && dist_x.abs > 0) || (dist_x.abs == 2 && dist_y.abs > 0)
        self.x += dist_x.positive? ? 1 : -1
        self.y += dist_y.positive? ? 1 : -1
      end
      visited << dup
      tail&.adjust(x, y)
    end

    def move_up
      self.y += 1
      tail.adjust(x, y)
    end

    def move_down
      self.y -= 1
      tail.adjust(x, y)
    end

    def move_left
      self.x -= 1
      tail.adjust(x, y)
    end

    def move_right
      self.x += 1
      tail.adjust(x, y)
    end
  end

  class Rope
    attr_reader :head

    def initialize(knots = 1)
      @head = Point.new(0, 0)
      curr = @head
      knots.times do
        curr.tail = Point.new(0, 0)
        curr = curr.tail
      end
    end

    def move(dir, times)
      method_name =
        case dir
        when "U"
          :move_up
        when "D"
          :move_down
        when "L"
          :move_left
        when "R"
          :move_right
        end

      times.to_i.times { head.send(method_name) }
      self
    end
  end

  def self.part1
    rope = Rope.new(1)
    ::File.foreach("./inputs/input09.txt") do |line|
      dir, times = line.split
      rope.move(dir, times)
    end

    rope.head.find_tail.visited.uniq.length
  end

  def self.part2
    rope = Rope.new(9)
    ::File.foreach("./inputs/input09.txt") do |line|
      dir, times = line.split
      rope.move(dir, times)
    end

    rope.head.find_tail.visited.uniq.length
  end
end

puts RopeBridge.part1
puts RopeBridge.part2
