# --- Day 18: Snailfish ---
# https://adventofcode.com/2021/day/18

class Snailfish
  def initialize
    @input = ::File.read("./inputs/input18.txt").split("\n").map { |row| eval(row) }
  end

  def part1 = @input.map { |pair| build pair }.reduce(&:add).magnitude
  def part2 = @input.flat_map { |i| @input.map { |j| build(i).add(build j).magnitude } }.max
  def build(value) = value.is_a?(Integer) ? value : build_pair(*value)
  def build_pair(left, right) = Snailfish::Pair.new(build(left), build(right))

  Pair = Struct.new(:left, :right) do
    attr_accessor :parent

    def initialize(left, right)
      left = create_value(left) if left.is_a?(Integer)
      right = create_value(right) if right.is_a?(Integer)
      assign_parent(left)
      assign_parent(right)
      super
    end

    def reduce
      while explode || split; end
      self
    end

    def first_left
      return false if !parent
      return parent.first_left if parent.left.contain?(self)
      parent.left.right_value
    end

    def first_right
      return false if !parent
      return parent.first_right if parent.right.contain?(self)
      parent.right.left_value
    end

    def find_explode
      return self if left.is_a?(Value) && right.is_a?(Value) && parent_count >= 4
      left.find_explode || right.find_explode
    end

    def explode
      return false unless value = find_explode
      first_left, first_right = value.first_left, value.first_right
      first_left.add_value(value.left) if first_left
      first_right.add_value(value.right) if first_right
      zero = value.parent.create_value(0)
      value.parent.left == value ? value.parent.left = zero : value.parent.right = zero
      true
    end

    def split
      return false unless child = find_split

      parent = child.parent
      split_pair = Pair.new(child.value / 2, (child.value / 2.0).ceil)
      split_pair.parent = parent
      parent.left == child ? parent.left = split_pair : parent.right = split_pair
      true
    end

    def assign_parent(child)
      child.parent = self
      child
    end

    def add(right) = Pair.new(self, right).reduce
    def create_value(value) = assign_parent(Value.new(value))
    def contain?(value) = value.id == id || left.contain?(value) || right.contain?(value)
    def left_value = left.left_value
    def right_value = right.right_value
    def find_split = left.find_split || right.find_split
    def id = @id ||= rand(10**5)
    def magnitude = (3 * left.magnitude) + (2 * right.magnitude)
    def parent_count = parent ? 1 + parent.parent_count : 0
    def to_s = [left, right].map(&:to_s)
  end

  Value = Struct.new(:value) do
    attr_accessor :parent
    alias magnitude value
    def add_value(value) = self.value += value.value
    def contain?(value) = false
    def find_explode = false
    def find_split = (self if value >= 10)
    def left_value = self
    def right_value = self
  end
end

snailfish = Snailfish.new
puts snailfish.part1
puts snailfish.part2
