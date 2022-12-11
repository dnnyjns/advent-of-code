# --- Day 10: Cathode-Ray Tube ---
# https://adventofcode.com/2022/day/10

class CathodeRayTube
  def self.build_cycles
    File.foreach("./inputs/input10.txt").flat_map do |line|
      line.start_with?("noop") ? nil : [nil, line.split(" ").last.to_i]
    end
  end

  def self.part1
    cycles = build_cycles
    cycle_20 = (1 + cycles[0...19].compact.sum) * 20
    cycle_60 = (1 + cycles[0...59].compact.sum) * 60
    cycle_100 = (1 + cycles[0...99].compact.sum) * 100
    cycle_140 = (1 + cycles[0...139].compact.sum) * 140
    cycle_180 = (1 + cycles[0...179].compact.sum) * 180
    cycle_220 = (1 + cycles[0...219].compact.sum) * 220

    cycle_20 + cycle_60 + cycle_100 + cycle_140 + cycle_180 + cycle_220
  end

  def self.part2
    cycles = build_cycles
    register = 1
    cycles.each_slice(40) { |c| register = print_cycle(c, register) }
  end

  def self.print_cycle(cycles, register)
    cycles.each_with_index do |v, index|
      if (register-1..register+1).include?(index)
        print "#"
      else
        print "."
      end
      register += v if v
    end

    puts
    register
  end
end

puts CathodeRayTube.part1
puts CathodeRayTube.part2
