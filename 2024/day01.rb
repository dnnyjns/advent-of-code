#### Part 1
file = File.read("./inputs/input01.txt")
left,right = file.scan(/(\d+)\s+(\d+)/).transpose
left.map!(&:to_i).sort!
right.map!(&:to_i).sort!
part1 = left.zip(right).sum { |l, r| (l-r).abs }
puts "Part 1: #{part1}"


#### Part 2
right_list_occurences = Hash.new(0)
right.each { |r| right_list_occurences[r] += 1 }
part2 = left.sum { |l| l * right_list_occurences[l] }
puts "Part 2: #{part2}"
