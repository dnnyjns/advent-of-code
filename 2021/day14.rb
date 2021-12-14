# --- Day 14: Extended Polymerization ---
# https://adventofcode.com/2021/day/14

class ExtendedPolymerization
  def initialize
    @polymer_template, rules = ::File.read("./inputs/input14.txt").split("\n\n")
    @rules = rules.split("\n").map { |r| r.split(" -> ") }.to_h
  end

  def part1
    polymer = step(10)
    min, max = polymer.chars.tally.values.minmax
    max - min
  end

  def part2
    step_part2(40)
  end

  def step(n)
    n.times.reduce(@polymer_template.chars) do |polymer|
      inserts = polymer.each_cons(2).map do |pair|
        @rules[pair.join]
      end

      polymer.zip(inserts).flatten
    end.join
  end

  def step_part2(n)
    pairs = Hash.new(0)
    counts = Hash.new(0)
    @polymer_template.chars.each_cons(2) do |pair|
      pairs[pair.join] += 1
    end

    @polymer_template.chars do |c|
      counts[c] += 1
    end

    n.times do
      next_pairs = pairs.clone
      pairs.each do |pair, count|
        insert = @rules[pair]
        counts[insert] += count
        next_pairs[pair] -= count
        next_pairs[pair[0] + insert] += count
        next_pairs[insert + pair[1]] += count
      end

      pairs = next_pairs
    end

    min, max = counts.values.minmax
    max - min
  end
end

extended_polymerization = ExtendedPolymerization.new
puts extended_polymerization.part1
puts extended_polymerization.part2
