# --- Day 4: Scratchcards ---
# https://adventofcode.com/2023/day/4

class Scratchcards
  def self.wins_per_row
    @wins_per_row ||= ::File.read("./inputs/input04.txt").split("\n").map do |row|
      winning_numbers, guesses = row.sub(/Card\s+(\d+): /, "").split(" | ")

      winning_numbers = winning_numbers.split(" ").map(&:to_i)
      guesses = guesses.split(" ").map(&:to_i)

      overlap = winning_numbers & guesses
      overlap.length
    end
  end

  def self.part1
    wins_per_row.map do |wins|
      (wins > 0) ? 2**(wins - 1) : 0
    end.sum.to_i
  end

  def self.part2
    card_count = Hash.new(0)
    wins_per_row.map.with_index do |wins, i|
      card_count[i] += 1

      card_count[i].times do
        wins.times do |j|
          card_count[i + j + 1] += 1
        end
      end
    end

    card_count.values.sum
  end
end

puts Scratchcards.part1
puts Scratchcards.part2
