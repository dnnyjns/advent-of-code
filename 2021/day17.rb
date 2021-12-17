# --- Day 17: Trick Shot ---
# https://adventofcode.com/2021/day/17

/x=(?<x1>-?\d+)..(?<x2>-?\d+), y=(?<y1>-?\d+)..(?<y2>-?\d+)/ =~ ::File.read("./inputs/input17.txt")
$xr = x1.to_i..x2.to_i
$yr = y1.to_i..y2.to_i

class TrickShot
  def part1 = trajectories.max_by(&:max_height).max_height
  def part2 = trajectories.length
  def trajectories = $xr.max.times.flat_map { |x| ($yr.min..$yr.min.abs - 1).map { |y| Trajectory.new(x, y).launch } }.compact

  class Trajectory
    class InsideRange < StandardError; end
    class OutsideRange < StandardError; end

    attr_reader :max_height

    def initialize(xv, yv)
      @xv, @yv    = xv, yv
      @x, @y      = 0, 0
      @max_height = 0
    end
    def inside_range? = $xr.cover?(@x) && $yr.cover?(@y)
    def outside_range? = @x > $xr.max || @y < $yr.min

    def launch
      loop { step }
    rescue InsideRange
      self
    rescue OutsideRange
      nil
    end

    def step
      @x += @xv
      @y += @yv
      @xv -= @xv > 0 ? 1 : -1 if @xv != 0
      @yv -= 1
      @max_height = [@max_height, @y].max
      raise InsideRange if inside_range?
      raise OutsideRange if outside_range?
    end
  end
end

trick_shot = TrickShot.new
puts trick_shot.part1
puts trick_shot.part2
