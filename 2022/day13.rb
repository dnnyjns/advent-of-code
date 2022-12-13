# --- Day 13: Distress Signal ---
# https://adventofcode.com/2022/day/13

class DistressSignal
  class OutOfOrder < StandardError; end

  def self.part1
    pairs = File.read("./inputs/input13.txt").split("\n\n").map do |pair|
      left, right = pair.split("\n")
      compare(eval(left), eval(right))
    rescue OutOfOrder
      false
    end

    pairs.map.with_index(1).select(&:first).sum { |_, i| i }
  end

  def self.part2
    pairs = File.read("./inputs/input13.txt").gsub('[]', '[0]').split("\n\n").flat_map do |pair|
      left, right = pair.split("\n")
      [eval(left), eval(right)]
    end << [[2]] << [[6]] << [[]]
    pairs = pairs.sort_by(&:flatten)

    (pairs.index([[2]])) *  (pairs.index([[6]]))
  end

  def self.compare(left, right)
    raise OutOfOrder if !right
    case [left, right]
    in [Integer, Integer]
      raise OutOfOrder if left > right
      left != right
    else
      left, right = Array(left), Array(right)
      ordered = left.zip(right).any? { |l, r| compare(l, r) }
      ordered ||= left.length < right.length
    end
  end
end

puts DistressSignal.part1
puts DistressSignal.part2
