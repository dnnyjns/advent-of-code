# --- Day 2: Rock Paper Scissors ---
# https://adventofcode.com/2022/day/2

class RockPaperScissors
  SCORES = {
    "A" => 1,
    "B" => 2,
    "C" => 3
  }

  LOSES = {
    "A" => "B",
    "B" => "C",
    "C" => "A",
  }

  def self.part1
    ::File.read("./inputs/input02.txt").tr("XYZ", "ABC").split("\n").reduce(0) do |sum, n|
      them, me = n.split(" ")

      sum + SCORES[me] + if LOSES[me] == them
        0
      elsif me == them
        3
      else
        6
      end
    end
  end

  def self.part2
    wins = LOSES.invert
    ::File.read("./inputs/input02.txt").split("\n").reduce(0) do |sum, n|
      them, me = n.split(" ")

      sum + case me
            when "X"
              SCORES[wins[them]]
            when "Y"
              3 + SCORES[them]
            when "Z"
              6 + SCORES[LOSES[them]]
            end
    end
  end
end

puts RockPaperScissors.part1
puts RockPaperScissors.part2
