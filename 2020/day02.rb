class PasswordPolicy
  attr_reader :rule1,
              :rule2,
              :character,
              :password

  def initialize(data)
    # 10-19 v: vvvvvvvvnvvvvvvvvvg
    unless /(?<limit>\d+-\d+)\s(?<character>[A-Za-z]):\s(?<password>.+)/ =~ data
      raise ArgumentError, "Data formatting incorrectly"
    end

    @rule1, @rule2 = limit.split("-").map(&:to_i)
    @character = character
    @password = password
  end

  def valid_by_range?
    character_count = password.count character
    (rule1..rule2).cover?(character_count)
  end

  def valid_by_position?
    (password[rule1 - 1] == character) ^ (password[rule2 - 1] == character)
  end
end

policies = File.open("./inputs/day02.txt", "r") do |f|
  f.each_line.map do |line|
    PasswordPolicy.new(line)
  end
end

puts "How many passwords are valid according to their policies?"
puts "Part 1: #{policies.count(&:valid_by_range?)}"
puts "Part 2: #{policies.count(&:valid_by_position?)}"
