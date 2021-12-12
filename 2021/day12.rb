# --- Day 12: Passage Pathing ---
# https://adventofcode.com/2021/day/12

class PassagePathing
  def initialize
    @cave_system = CaveSystem.new
    ::File.foreach("./inputs/input12.txt") do |row|
      a, b = row.chomp.split("-")
      @cave_system.add_edge(a, b)
    end
  end

  def part1
    find_paths.count
  end

  def part2
    find_paths(part2: true).count
  end

  def find_paths(part2: false, paths: [Path.new(@cave_system, part2: part2)])
    return paths if paths.all?(&:finished?)
    find_paths paths: paths.flat_map(&:visit_all), part2: part2
  end

  class Path
    def initialize(cave_system, caves: [cave_system.find_cave('start')], part2:)
      @cave_system = cave_system
      @caves       = caves
      @part2       = part2
      @visited     = Hash.new(0)

      caves.each { |cave| visit cave }
    end

    def finished?
      current == "end"
    end

    def visit_all
      return self if finished?
      caves_to_visit.map do |next_cave|
        Path.new(@cave_system, caves: [*@caves, next_cave], part2: @part2)
      end
    end

    private

    def current
      @caves.last
    end

    def caves_to_visit
      current.edges.select { |cave| can_visit_cave? cave }
    end

    def can_visit_cave?(cave)
      return true if cave.large? && cave.edges.any? { |cave| can_visit_cave? cave }
      return !visited?(cave) if !@part2

      !visited?(cave) ||
        (cave.small? && @visited[cave] == 1 && @visited.none? { |cave, count| cave.small? && count > 1 })
    end

    def visit(cave)
      @visited[cave] += 1
    end

    def visited?(cave)
      @visited[cave] > 0
    end
  end

  class CaveSystem
    include Enumerable

    def initialize
      @caves = []
    end

    def each(&block)
      @caves.each(&block)
    end

    def find_cave(cave, &block)
      detect(block) { |c| c == cave }
    end

    def add_edge(cave, edge)
      a = find_or_create(cave)
      b = find_or_create(edge)

      a.add_edge(b)
      b.add_edge(a)
    end

    private

    def add_cave(value)
      Cave.new(value).tap do |cave|
        @caves << cave
      end
    end

    def find_or_create(value)
      find_cave(value) { add_cave(value) }
    end
  end

  class Cave
    attr_accessor :value, :edges

    def initialize(value)
      @edges = []
      @value = value
    end

    def small?
      !large? && !["start", "end"].include?(value)
    end

    def large?
      value == value.upcase
    end

    def add_edge(edge)
      edges << edge
    end

    def ==(other)
      value == (other.is_a?(String) ? other : other.value)
    end
  end
end

passage_pathing = PassagePathing.new
puts passage_pathing.part1
puts passage_pathing.part2
