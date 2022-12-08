# --- Day 6: Tuning Trouble ---
# https://adventofcode.com/2022/day/6

class TuningTrouble
  def self.detect_marker(n)
    n + File.read("./inputs/input06.txt").chomp.each_char.each_cons(n).with_index.detect do |row, _|
      row.tally.values.all? { |v| v == 1 }
    end.last
  end

  def self.part1
    detect_marker(4)
  end

  def self.part2
    detect_marker(14)
  end
end

puts TuningTrouble.part1
puts TuningTrouble.part2
