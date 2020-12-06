# --- Day 6: Custom Customs ---
# https://adventofcode.com/2020/day/6

class CustomCustoms
  class DeclartionGroup
    attr_reader :declarations, :answers

    def initialize(declarations)
      @declarations = declarations
      @answers      = Hash.new(0)

      @declarations.each do |row|
        row.split("").each do |answer|
          @answers[answer] += 1
        end
      end
    end

    def part1
      answers.keys.length
    end

    def part2
      size_of_group = declarations.length
      answers.values.count { |v| v == size_of_group }
    end

    def to_s
      "#{declarations.join("-")} || #{answers.keys.join(",")} || #{part1}"
    end
  end

  attr_reader :groups
  def initialize
    lines   = ::File.read("./day06.txt")
    @groups = lines.split(/^\n/).map do |group|
      DeclartionGroup.new(group.split("\n"))
    end
  end

  def part1
    groups.sum(&:part1)
  end

  def part2
    groups.sum(&:part2)
  end
end

cc = CustomCustoms.new
puts "--- Day 6: Custom Customs ---"
puts "Part 1: #{cc.part1}"
puts "Part 2: #{cc.part2}"
