# --- Day 15: Chiton ---
# https://adventofcode.com/2021/day/15
require 'matrix'
require 'set'

class Chiton
  def initialize
    @input = ::File.read("./inputs/input15.txt").split("\n")
  end

  def part1
    points = @input.map.with_index { |row, y| row.chars.map.with_index { |risk, x| Point.new(x, y, risk.to_i) } }
    cave = build_cave points
    cave.calculate_risk
  end

  def part2
    input = @input.map(&:chars)
    m, n = input.length, input.first.length
    points = Matrix.build(m * 5, n * 5) do |row, column|
      risk = input[row % m][column % n].to_i + (column / n) + (row / m)
      risk %= 9
      Point.new(column, row, risk == 0 ? 9 : risk)
    end

    cave = build_cave points.to_a
    cave.calculate_risk
  end

  def build_cave(points)
    Cave.new.tap do |cave|
      points.each do |row|
        row.each do |point|
          right = points[point.y]&.at(point.x + 1)
          down = points[point.y + 1]&.at(point.x)
          cave.add_edge(point, right) if right
          cave.add_edge(point, down) if down
        end
      end
    end
  end

  Point = Struct.new(:x, :y, :risk)
  class Cave
    attr_reader :graph, :nodes, :previous, :distance

    def initialize
      @graph = Hash.new { Set.new }
      @nodes = []
    end

    def calculate_risk
      source = @nodes.min_by { |n| [n.x, n.y] }
      target = @nodes.max_by { |n| [n.x, n.y] }
      dijkstra(source)
      path = find_path(target)
      path.map(&:risk).sum - source.risk
    end

    def add_edge(a, b)
      connect(a, b)
      connect(b, a)
    end

    def dijkstra(source)
      @dist = {}
      @prev = {}
      queue = Set.new [source]

      nodes.each do |node|
        @dist[node] = ::Float::INFINITY
        @prev[node] = -1
      end

      @dist[source] = 0

      while !queue.empty?
        u = queue.min_by{ |n| @dist[n] }
        if (@dist[u] == Float::INFINITY)
          break
        end
        queue.delete(u)
        graph[u].each do |vertex|
          alt = @dist[u] + vertex.risk
          if alt < @dist[vertex]
            @dist[vertex] = alt
            @prev[vertex] = u
            queue << vertex
          end
        end
      end
    end

    def find_path(dest, path = [])
      if @prev[dest] != -1
        find_path @prev[dest], path
      end
      path << dest
    end

    def connect(a, b)
      nodes << a
      graph[a] <<= b
    end
  end
end

chiton = Chiton.new
puts chiton.part1
puts chiton.part2
