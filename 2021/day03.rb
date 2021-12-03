# --- Day 3: Binary Diagnostic ---
# https://adventofcode.com/2021/day/3

class BinaryDiagnostic
  def initialize
    @lines = ::File.read("./inputs/input03.txt").split("\n")
  end

  def part1
    count = Hash.new(0)
    @lines.each { |line| line.each_char.with_index { |c, i| c == "1" ? count[i] += 1 : count[i] -= 1 } }
    gamma = count.values.map { |v| v.positive? ? "1" : "0" }.join.to_i(2)
    epsilon = gamma ^ (1 << gamma.bit_length) - 1

    gamma * epsilon
  end

  def part2
    Part2.new(@lines).result
  end

  class Part2
    def initialize(lines)
      @lines = lines
    end

    def result
      oxygen_generator_rating * co2_scrubber_rating
    end

    def oxygen_generator_rating
      calculate_rating { |count| count >= 0 }
    end

    def co2_scrubber_rating
      calculate_rating { |count| count < 0 }
    end

    private

    def bit_length
      @lines.first.length
    end

    def calculate_rating(&block)
      result = @lines

      bit_length.times do |i|
        result = select_bit_criteria(result, i, &block)
        break if result.length == 1
      end

      if result.length != 1
        raise "Oops"
      end

      result.first.to_i(2)
    end

    def count_bits(input, index)
      count = 0
      input.each { |rate| rate[index] == "1" ? count += 1 : count -= 1 }
      count
    end

    def select_bit_criteria(input, index)
      flag = (yield count_bits(input, index)) ? "1" : "0"
      input.select { |row| row[index] == flag }
    end
  end
end


binary_diagnostic = BinaryDiagnostic.new

puts binary_diagnostic.part1
puts binary_diagnostic.part2
