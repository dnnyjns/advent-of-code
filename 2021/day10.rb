# --- Day 10: Smoke Basin ---
# https://adventofcode.com/2021/day/10

OPENING_CHAR_MAPPING = {
  "(" => ")",
  "[" => "]",
  "{" => "}",
  "<" => ">",
}

CLOSING_CHAR_MAPPING =  OPENING_CHAR_MAPPING.invert

SCORE = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137
}

SCORE2 = {
  ")" => 1,
  "]" => 2,
  "}" => 3,
  ">" => 4
}

class SyntaxScoring
  def initialize
    @input = ::File.read("./inputs/input10.txt").split("\n")
    @navigation_subsystem = NavigationSubsystem.new(@input)
  end

  def part1
    @navigation_subsystem.each_illegal_character.map { |c| SCORE[c] }.sum
  end

  def part2
    scores = @navigation_subsystem.each_incomplete_line.map do |line|
      line.reduce(0) do |score, c|
        score * 5 + SCORE2[c]
      end
    end

    scores = scores.sort.to_a

    scores[(scores.length - 1)/2]
  end

  class NavigationSubsystem
    include Enumerable

    def initialize(input)
      @lines = input.map { |row| Line.new(row) }
    end

    def each(&block)
      @lines.each(&block)
    end

    def each_illegal_character
      lazy.map(&:illegal_character).reject(&:nil?)
    end

    def each_incomplete_line
      lazy.reject(&:illegal_character).map(&:auto_complete!)
    end

    class Line
      include Enumerable

      class IllegalCharacter < StandardError
        attr_reader :character
        def initialize(character)
          super()
          @character = character
        end
      end

      def initialize(input)
        @input = input
      end

      def each(&block)
        @input.chars.each(&block)
      end

      def auto_complete!
        tags = []

        each do |char|
          tag = tags.last
          if OPENING_CHAR_MAPPING[char]
            tags.push(char)
          elsif tag && CLOSING_CHAR_MAPPING[char] == tag
            tags.pop
          else
            raise IllegalCharacter, char
          end
        end

        tags.map { |c| OPENING_CHAR_MAPPING[c] }.reverse
      end

      def illegal_character
        @illegal_character ||= begin
          auto_complete!
        rescue IllegalCharacter => e
          e.character
        else
          nil
        end
      end

    end
  end

end

aoc = SyntaxScoring.new
puts aoc.part1
puts aoc.part2
