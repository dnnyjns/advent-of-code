# --- Day 5: Supply Stacks ---
# https://adventofcode.com/2022/day/5

class SupplyStacks
  def self.part1
    supply_stacks = new
    supply_stacks.moves.each do |move|
      supply_stacks.move_pop(move[:count], move[:from], move[:to])
    end
    supply_stacks.top
  end

  def self.part2
    supply_stacks = new
    supply_stacks.moves.each do |move|
      supply_stacks.move_push(move[:count], move[:from], move[:to])
    end
    supply_stacks.top
  end

  def initialize     = @input = ::File.read("./inputs/input05.txt").split("\n\n")
  def stacks         = @stacks ||= Stacks.new(@input.first)
  def top            = stacks.map(&:last).join
  def move_pop(...)  = stacks.move_pop(...)
  def move_push(...) = stacks.move_push(...)

  def moves
    @moves ||= @input.last.split("\n").map do |row|
      /move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)/ =~ row
      { count: count.to_i, from: from.to_i, to: to.to_i }
    end
  end

  class Stacks < Array
    def initialize(str)
      first, *stack = str.split("\n").reverse

      stacks = super(first.scan(/\d+/).length) { [] }
      stack.each do |row|
        stacks.each_with_index do |stack, i|
          s = i * 4
          e = s + 4
          char = row[s...e].strip.scan(/[A-Za-z]/).first
          stack.push(char) if char
        end
      end
    end

    def move_pop(count, from, to) = count.times { self[to - 1].push self[from - 1].pop }
    def move_push(count, from, to) = self[to - 1].concat(count.times.map { self[from - 1].pop }.reverse)
  end
end

puts SupplyStacks.part1
puts SupplyStacks.part2
