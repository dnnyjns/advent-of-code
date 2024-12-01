#### Part 1
file = File.read("./inputs/input01.txt")
left,right = file.scan(/(\d+)\s+(\d+)/).transpose
left.map!(&:to_i).sort!
right.map!(&:to_i).sort!
part1 = left.zip(right).sum { |l, r| (l-r).abs }
puts "Part 1: #{part1}"


#### Part 2
right_tally = right.tally
part2 = left.sum { |l| l * right_tally[l].to_i }
puts "Part 2: #{part2}"
