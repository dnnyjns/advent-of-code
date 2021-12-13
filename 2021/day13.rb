# --- Day 13: Transparent Origami ---
# https://adventofcode.com/2021/day/13

class TransparentOrigami
  def initialize
    dots, folds = ::File.read("./inputs/input13.txt").split("\n\n").map { |r| r.split "\n" }
    @dots = dots.map { |d| d.split(",").map(&:to_i) }
    @folds = folds.map { |f| f.split("fold along ").last }
  end

  def part1
    first_fold = @folds.first
    fold(first_fold, @dots).length
  end

  def part2
    dots = @folds.reduce(@dots) do |dots, f|
      fold(f, dots)
    end

    code dots
  end

  def fold(str, dots)
    axis, coord = str.split("=")
    coord = coord.to_i
    folded = dots.select { |x, y| axis == "x" ? x < coord : y < coord }
    dots.each do |(dot_x, dot_y)|
      if axis == "x" && dot_x > coord
        folded << [2*coord-dot_x, dot_y]
      elsif axis == "y" && dot_y > coord
        folded << [dot_x, 2*coord-dot_y]
      end
    end

    folded.uniq
  end

  def code(dots)
    dots.reduce([]) do |ary, (x, y)|
      ary[y] ||= []
      ary[y][x] = true
      ary
    end.map do |y|
      y.map do |x|
        if x
          "#"
        else
          "."
        end
      end.join
    end.join("\n")
  end
end

transparent_origami = TransparentOrigami.new
puts transparent_origami.part1
puts transparent_origami.part2
