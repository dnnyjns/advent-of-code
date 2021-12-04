# --- Day 4: Giant Squid ---
# https://adventofcode.com/2021/day/4

WHITESPACE_REGEX = /[^\S\r\n]/
marked_numbers = /\d?\dx#{WHITESPACE_REGEX}*/
unmarked_numbers = /\d?\dx?#{WHITESPACE_REGEX}*/

BINGO_REGEX = 5.times.reduce(/(^(#{marked_numbers}){5}$)/) do |regex, index|
  /#{regex}|((^(#{unmarked_numbers}){#{index}}(#{marked_numbers})(#{unmarked_numbers}){#{4-index}}(\n|\z)){5})/
end

class GiantSquid
  def initialize
    input = ::File.read("./inputs/input04.txt").gsub(/#{WHITESPACE_REGEX}#{WHITESPACE_REGEX}+/, " ").gsub(/^ /, "")
    drawn_numbers = input.each_line.first
    @numbers_to_draw = drawn_numbers.chomp.split(",")
    @board = input.sub("#{drawn_numbers}\n", "")
  end

  def part1
    play_bingo!
  end


  def part2
    play_bingo!(stop_on_first_winner: false)
  end

  def play_bingo!(stop_on_first_winner: true)
    board = @board
    winning_number = nil
    winning_boards = []

    @numbers_to_draw.each do |number|
      board = board.gsub(/\b#{number}\b/, "#{number}x")
      deleted_boards = complete_boards!(board)

      if deleted_boards.any?
        winning_boards = deleted_boards
        winning_number = number

        break if stop_on_first_winner
      end
    end

    if winning_boards.length > 1
      raise "Oops"
    end

    winning_board = winning_boards.first
    sum_of_all_unmarked_numbers = winning_board.scan(/\d+\b/).map(&:to_i).reduce(&:+)
    sum_of_all_unmarked_numbers * winning_number.to_i
  end

  private

  def complete_boards!(boards)
    boards.split(/\R\R+/).select { |board| board.match(BINGO_REGEX) }.each do |board|
      boards.gsub!(board, "")
    end
  end
end


giant_squid = GiantSquid.new

puts giant_squid.part1
puts giant_squid.part2
