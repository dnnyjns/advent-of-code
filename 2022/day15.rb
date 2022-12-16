# --- Day 15: Beacon Exclusion Zone ---
# https://adventofcode.com/2022/day/15

class BeaconExclusionZone
  PART1_TARGET = 2000000
  PART2_TARGET = 4000000
  @beacons = {}

  def self.part1
    sensors = build_sensors
    ranges = sensors.map { |s| s.yrange(PART1_TARGET) }
    ranges = merge_ranges(ranges)
    ranges.map(&:count).sum - @beacons.keys.select  { |x, y| y == PART1_TARGET && ranges.any? { |r| r.cover?(x) } }.length
  end

  def self.part2
    sensors = build_sensors
    PART2_TARGET.downto(0).each do |y|
      ranges = sensors.map { |s| s.yrange(y) }.reject { |r| r.first >= r.last }
      ranges = merge_ranges(ranges)
      if ranges.length > 1
        x = ranges.first.last + 1
        return (x * PART2_TARGET) + y
      end
    end
  end

  def self.build_sensors
    File.foreach("./inputs/input15.txt").map do |line|
      x1, y1, x2, y2 = line.scan(/-?\d+/).map(&:to_i)
      Sensor.new(*[x1, y1, x2, y2])
    end
  end

  def self.merge_ranges(ranges)
    ranges = ranges.sort_by {|r| r.first }
    *outages = ranges.shift
    ranges.each do |r|
      lastr = outages[-1]
      if lastr.last >= r.first - 1
        outages[-1] = lastr.first..[r.last, lastr.last].max
      else
        outages.push(r)
      end
    end
    outages
  end

  class Sensor
    attr_reader :x, :y, :manhattan_distance
    def initialize(x, y, bx, by)
      @x, @y = x, y
      @manhattan_distance = (x - bx).abs + (y - by).abs
    end

    def yrange(target_y)
      x_offset = manhattan_distance - (y - target_y).abs
      (x - x_offset..x + x_offset)
    end
  end
end

puts BeaconExclusionZone.part1
puts BeaconExclusionZone.part2
