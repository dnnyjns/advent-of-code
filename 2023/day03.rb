# --- Day 3: GearRatios ---
# https://adventofcode.com/2023/day/3

class GearRatios
  def self.part1
    input = ::File.read("./inputs/input03.txt").split("\n")
    sum = 0
    input.each_with_index do |row, y|
      x = 0
      row.scan(/\d+|./) do |char|
        if /\d/.match?(char) && adjacent_to?(input, y, x, char.length) { /[^.\d]/ }
          sum += char.to_i
        end
        x += char.length
      end
    end
    sum
  end

  def self.adjacent_to?(input, y, x, length, &block)
    (x...x + length).any? do |fa|
      [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]].any? do |di, dj|
        ni, nj = y + di, fa + dj
        if ni.between?(0, input.length - 1) && nj.between?(0, input[0].length - 1)
          input[ni][nj] =~ block.call
        end
      end
    end
  end

  def self.part2
    input = ::File.read("./inputs/input03.txt").split("\n")
    sum = 0
    input.each_with_index do |row, y|
      row.chars.each_with_index do |char, x|
        if char == "*"
          sum += gear_ratio(input, y, x, char.length)
        end
      end
    end
    sum
  end

  def self.gear_ratio(input, y, x, length)
    numbers = Hash.new { |h, k| h[k] = [] }
    [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]].each do |di, dj|
      ni, nj = y + di, x + dj
      if ni.between?(0, input.length - 1) && nj.between?(0, input[0].length - 1) && input[ni][nj] =~ /\d/
        numbers[ni] << nj
      end
    end

    ratio = 1
    count = 0
    (y - 1..y + 1).each do |i|
      row = input[i] || ""
      x = 0
      row.scan(/\d+|./) do |char|
        if /\d/.match?(char) && Array(numbers[i]).any? { |j| (x...x + char.length).cover?(j) }
          ratio *= char.to_i
          count += 1
        end
        x += char.length
      end
    end
    return 0 if count != 2
    ratio
  end
end

puts GearRatios.part1
puts GearRatios.part2
