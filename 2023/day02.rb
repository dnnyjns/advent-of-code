# --- Day 2: Cube Conundrum ---
# https://adventofcode.com/2023/day/2

class CubeConundrum
  def self.parse_games
    ::File.read("./inputs/input02.txt").split("\n").map do |row|
      /Game (?<id>\d+): (?<batches>.+)/ =~ row

      batches = batches.split("; ").map do |batch|
        red = batch.scan(/(?<red>\d+) red/).flatten.first.to_i
        green = batch.scan(/(?<green>\d+) green/).flatten.first.to_i
        blue = batch.scan(/(?<blue>\d+) blue/).flatten.first.to_i
        Batch.new(red, green, blue)
      end

      Game.new(id.to_i, batches)
    end
  end

  def self.part1
    parse_games.select { |game| game.contains_atmost(red: 12, green: 13, blue: 14) }.map(&:id).sum
  end

  def self.part2
    parse_games.map(&:minimum_power).sum
  end

  Batch = Struct.new(:red, :green, :blue) do
    def contains_atmost(red:, green:, blue:)
      self.red <= red && self.green <= green && self.blue <= blue
    end
  end

  Game = Struct.new(:id, :batches) do
    def contains_atmost(red:, green:, blue:)
      batches.all? { |batch| batch.contains_atmost(red: red, green: green, blue: blue) }
    end

    def max_red
      batches.map(&:red).max
    end

    def max_green
      batches.map(&:green).max
    end

    def max_blue
      batches.map(&:blue).max
    end

    def minimum_power
      max_red * max_green * max_blue
    end
  end
end

puts CubeConundrum.part1
puts CubeConundrum.part2
