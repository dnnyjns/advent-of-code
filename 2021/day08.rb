# --- Day 8: Seven Segment Search ---
# https://adventofcode.com/2021/day/8

class String
  def -(other)
    (self.chars - other.chars).join
  end

  def superset(other)
    (other - self) == "" && other != self
  end
end

class SevenSegmentSearch
  def initialize
    @input = ::File.read("./inputs/input08.txt").split("\n")
  end

  def part1
    @input.map { |row| row.split(" | ").last }.reduce(0) { |sum, row| sum + row.split(" ").count { |d| [2,3,4,7].include?(d.length) } }
  end

  def part2
    @input.map do |row|
      decipher_sequence, sequence_to_calc = row.split(" | ").map { |r| r.split(" ") }
      decipher_sequence = decipher_sequence.map { |sequence| sort_sequence(sequence) }
      sequence_to_calc = sequence_to_calc.map { |sequence| sort_sequence(sequence) }
      mapping = build_mapping decipher_sequence

      sequence_to_calc.map { |sequence| mapping[sequence].to_s }.join.to_i
    end.flatten.reduce(&:+)
  end

  def sort_sequence(sequence)
    sequence.split("").sort.join
  end

  def build_mapping(sequences)
    sequence_mapping = []
    sequence_mapping[1] = sequences.detect { |r| r.length == 2 }
    sequence_mapping[4] = sequences.detect { |r| r.length == 4 }
    sequence_mapping[7] = sequences.detect { |r| r.length == 3 }
    sequence_mapping[8] = sequences.detect { |r| r.length == 7 }

    without_8 = sequences.filter { |x| x != sequence_mapping[8] }
    sequence_mapping[9] = without_8.detect { |sequence| sequence.superset(sequence_mapping[4]) }

    letters = {}
    letters['a'] = sequence_mapping[7] - sequence_mapping[1]
    letters['e'] = sequence_mapping[8] - sequence_mapping[9]
    letters['g'] = sequence_mapping[9] - sequence_mapping[4] - letters['a']

    sequence_mapping[0] = without_8.detect { |sequence| sequence.superset(sequence_mapping[7] + letters['e'] + letters['g']) }
    letters['b'] = sequence_mapping[0] - sequence_mapping[7] - letters['e'] - letters['g']
    letters['d'] = sequence_mapping[4] - sequence_mapping[1] - letters['b']
    sequence_mapping[3] = sequence_mapping[9] - letters['b']
    sequence_mapping[6] = (without_8 - sequence_mapping).detect { |sequence| sequence.superset(letters['a'] + letters['b'] + letters['d'] + letters['e'] + letters['g']) }
    sequence_mapping[5] = sequence_mapping[6] - letters['e']
    sequence_mapping[2] = (without_8 - sequence_mapping).first

    sequence_mapping.zip(0..sequence_mapping.length).to_h
  end
end

sss = SevenSegmentSearch.new
puts sss.part1
puts sss.part2
