
require_relative './card.rb'


class Board
  attr_accessor :board
  attr_reader :current_letters

  def initialize
    @board = Array.new(4) {Array.new(4) {Card.new}}
    # debugger
    @current_letters = [] # => ["E", "U", "A", "S", "N", "T", "G", "F"]
  end

  def new_board
    @board = Array.new(4) {Array.new(4) {Card.new}}
    get_random_letters
    populate_board
    # render_board
  end

  def get_random_letters
    half_board = @board.length * 2
    all_letters = ('A'..'Z').to_a.shuffle
    current_letters = (all_letters.slice(0, half_board) * 2).shuffle
    @current_letters = current_letters
  end

  def populate_board
    current_letters_idx = 0
    i = 0
    while i < @board.length
      j = 0
      while j < @board.length
        @board[i][j].hidden_value = @current_letters[current_letters_idx]
        current_letters_idx += 1
        j += 1
      end
      i += 1
    end
  end

  def render_board
    # render winning board
    puts '  0 1 2 3'
    @board.each_with_index do |row, i|
      print i.to_s + ' '
      row.each_with_index do |el, i|
        print el.value + ' '
        puts if i == row.length - 1
      end
    end
  end

  def update_board(match1, match2)
    first_match = @board[match1.first][match1.last]
    second_match = @board[match2.first][match2.last]

    first_match.value = first_match.hidden_value
    second_match.value = second_match.hidden_value
  end

  def display_guess(user_input)
    card = @board[user_input.first][user_input.last]
    card.reveal
  end

  def hide_guess(user_input)
    card = @board[user_input.first][user_input.last]
    card.hide
  end

  def win?
    @board.flatten.all? do |card|
      card.match?
    end
  end
end


# b = Board.new
# b.get_random_letters
# b.current_letters
# b.populate_board
# b.render_board

# b.board[0][0] = 'T'
# b.render_board

# # board instance variable
# # board = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
# board = Array.new(4) {Array.new(4) { }}

# # board[0][0] = 0
# # board[0][1] = 1
# # board[0][2] = 2
# # board[0][3] = 3





