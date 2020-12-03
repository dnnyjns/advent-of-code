# --- Day 3: Toboggan Trajectory ---
# https://adventofcode.com/2020/day/3

class TobogganTrajectory
  def initialize
    @inputs = ::File.foreach("./day03.txt").map do |line|
      line.strip.split("")
    end
  end

  def count_trees(right, down)
    cur_right  = right
    cur_down   = down
    tree_count = 0

    @inputs.each.with_index do |row, index|
      next if index != cur_down

      tree_count += 1 if row[cur_right % row.length] == "#"
      cur_right  += right
      cur_down   += down
    end

    tree_count
  end
end

day3  = TobogganTrajectory.new
part1 = day3.count_trees(3, 1)
part2 = [[1,1], [3,1], [5,1], [7,1], [1,2]].reduce(1) { |product, (right, down)| product * day3.count_trees(right, down) }

puts "--- Day 3: Toboggan Trajectory ---"
puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
