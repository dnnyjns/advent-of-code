# --- Day 11: Monkey In The Middle ---
# https://adventofcode.com/2022/day/11

class MonkeyInTheMiddle
  class Monkey
    attr_accessor :decrease_worry_level, :divisible_by, :inspected_count

    def initialize(starting_items, operation_eval, divisible_by, on_true, on_false)
      @items = starting_items
      @operation_eval = operation_eval
      @divisible_by = divisible_by
      @on_true = on_true
      @on_false = on_false
      @inspected_count = 0
    end

    def throw_items
      items = @items
      @items = []
      items.map do |item|
        throw_item(item)
      end
    end

    def add_item(item) = @items << item
    def test_item(item) = item % @divisible_by == 0 ? @on_true : @on_false

    def inspect_item(old)
      @inspected_count += 1
      new_item = eval(@operation_eval)
    end

    def throw_item(worry_level)
      worry_level = inspect_item(worry_level)
      worry_level = decrease_worry_level[worry_level]

      throw_to = test_item(worry_level)

      [worry_level, throw_to]
    end
  end

  class Monkeys < Array
    def business = map(&:inspected_count).max(2).reduce(&:*)
    def throw_items(n, &block)
      each { |monkey| monkey.decrease_worry_level = block }

      n.times do
        each do |monkey|
          items_to_throw = monkey.throw_items

          items_to_throw.each do |worry_level, new_monkey|
            self[new_monkey].add_item(worry_level)
          end
        end
      end
      self
    end
  end

  def self.monkeys
    File.read("./inputs/input11.txt").split("\n\n").map { |row| row.split("\n") }.map do |row|
      _, starting_str, operation_str, test_str, on_true_str, on_false_str = row

      /Starting items: (?<starting_items>.+)/ =~ starting_str
      starting_items = starting_items.split(", ").map(&:to_i)

      /Operation: new = (?<operation_eval>.+)/ =~ operation_str

      /Test: divisible by (?<divisible_by>\d+)/ =~ test_str
      divisible_by = divisible_by.to_i

      /If true: throw to monkey (?<on_true>\d+)/ =~ on_true_str
      on_true = on_true.to_i

      /If false: throw to monkey (?<on_false>\d+)/ =~ on_false_str
      on_false = on_false.to_i

      Monkey.new(
        starting_items,
        operation_eval,
        divisible_by,
        on_true,
        on_false
      )
    end.yield_self { |monkeys| Monkeys.new(monkeys) }
  end

  def self.part1
    monkeys.throw_items(20) { |w| w / 3 }.business
  end

  def self.part2
    monkeys = self.monkeys
    reduce_worry_level = monkeys.map(&:divisible_by).reduce(&:*)
    monkeys.throw_items(10000) { |w| w % reduce_worry_level }.business
  end
end

puts MonkeyInTheMiddle.part1
puts MonkeyInTheMiddle.part2
