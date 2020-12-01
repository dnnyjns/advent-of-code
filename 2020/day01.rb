@mapping = {}
File.open("./inputs/day01.txt", "r") do |f|
  f.each_line do |line|
    @mapping[line.to_i] = true
  end
end

def find_two(target = 2020)
  @mapping.keys.each do |expense1|
    expense2 = target - expense1
    return expense1, expense2 if @mapping[expense2]
  end

  return
end

def find_three(target = 2020)
  @mapping.keys.each do |expense1|
    expenses = find_two(target - expense1)
    return [expense1, *expenses] if expenses
  end

  return
end

expense1, expense2 = find_two
puts "Part1 -- (#{expense1} + #{expense2} = 2020) #{expense1} * #{expense2} = #{expense1 * expense2}"

expense1, expense2, expense3 = find_three
puts "Part2 -- (#{expense1} + #{expense2} + #{expense3} = 2020) #{expense1} * #{expense2} * #{expense3} = #{expense1 * expense2 * expense3}"
