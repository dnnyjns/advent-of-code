# --- Day 4: Passport Processing ---
# https://adventofcode.com/2020/day/4

class PassportProcessing
  class Passport < Hash
    FIELDS = {
      byr: ->(value) { value.to_i >= 1920 && value.to_i <= 2002 },
      iyr: ->(value) { value.to_i >= 2010 && value.to_i <= 2020 },
      eyr: ->(value) { value.to_i >= 2020 && value.to_i <= 2030 },
      hgt: ->(value) do
        if /^(?<height>\d+)cm$/ =~ value
          height.to_i >= 150 && height.to_i <= 193
        elsif /^(?<height>\d+)in$/ =~ value
          height.to_i >= 59 && height.to_i <= 76
        else
          false
        end
      end,
      hcl: ->(value) { !!(/^#[a-z0-9]{6}$/ =~ value) },
      ecl: ->(value) { !!(/^(amb|blu|brn|gry|grn|hzl|oth)$/ =~ value) },
      pid: ->(value) { !!(/^\d{9}$/ =~ value) }
    }


    def valid_part1?
      FIELDS.keys.reduce(true) do |valid, field|
        valid && key?(field.to_s)
      end
    end

    def valid_part2?
      FIELDS.reduce(true) do |valid, (field, validation)|
        valid && self[field.to_s] && validation.call(self[field.to_s])
      end
    end
  end

  attr_reader :passports

  def initialize
    @passports = []
    current_pair = Passport.new
    ::File.foreach("./day04.txt") do |l|
      pairs = l.strip.split(" ")

      if pairs.any?
        pairs.each do |p|
          key, value = p.split(":")
          current_pair[key] = value
        end
      else
        @passports << current_pair
        current_pair = Passport.new
      end
    end

    @passports << current_pair
  end

  def part1
    passports.count(&:valid_part1?)
  end

  def part2
    passports.count(&:valid_part2?)
  end
end

pp = PassportProcessing.new
puts "--- Day 4: Passport Processing ---"
puts "Part 1: #{pp.part1}"
puts "Part 2: #{pp.part2}"
