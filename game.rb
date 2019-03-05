

require 'byebug'
require_relative './board.rb'
require_relative './human_player.rb'

class Game
  attr_accessor :board

  def initialize(board)
    @board = board
    @current_guess = []
    @prev_guess = []
    @turn = 'first'
    @players = [] # => ['Kenny', 'Sasha']
    @current_player_idx = 0
    @current_player = @players[@current_player_idx]
  end

  def set_player_names
    (1..2).each do |num|
      puts "Player #{num}, enter you name..."
      name = gets.chomp
      @players << HumanPlayer.new(name)
    end
    # debugger
    @current_player = @players[@current_player_idx]
  end

  def switch_player
    @current_player_idx = (@current_player_idx + 1) % 2
    @current_player = @players[@current_player_idx]
  end

  def update_player_score
    @current_player.score += 1
  end

  def display_player_scores
    @players.each do |player|
      puts "#{player.name}'s score: #{player.score}"
    end
  end

  def play_game
    set_player_names
    new_board
    prompt
  end

  def new_board
    @board.new_board
  end

  def clear_screen
    system("clear")
  end

  def sleep_screen
    sleep(2)
  end

  def prompt
    clear_screen
    display_player_scores
    puts "\n"
    @board.render_board
    puts "\n"
    # debugger
    puts "#{@players[@current_player_idx].name}'s turn..."
    puts "Please enter the position of the card you'd like to flip (e.g. '2,3')"  
    make_guess
  end

  def make_guess
    user_input = gets.chomp.split(',').map(&:to_i)
    if valid_guess?(user_input)
      # p 'valid guess!'
      # sleep_screen
      set_guess(user_input)
      prompt
    else
      p 'invalid guess. try again!'
      # sleep_screen
      make_guess
    end
  end

  def valid_guess?(guess)
    board_size = @board.board.length
    
    guess_check = (guess.first >= 0) && (guess.first < board_size) && (guess.last >= 0) && (guess.last < board_size) && (guess != @current_guess)

    return false if !guess_check

    board_value = @board.board[guess.first][guess.last].value
    guess.is_a?(Array) && guess.length == 2 && board_value == ' ' ? true : false
  end

  def set_guess(user_input)
    # for first guess
    if @turn == 'first'
      @current_guess = user_input
      display_guess(user_input)
      @turn = 'second'
    elsif @turn == 'second'
      @prev_guess, @current_guess = @current_guess, user_input
      display_guess(user_input)
      # debugger
      check_win

    end
  end

  # show chosen card
  def display_guess(user_input) # => [0,0]
    clear_screen
    # debugger
    display_player_scores
    puts "\n"
    @board.display_guess(user_input)
    @board.render_board
    sleep_screen
    # clear_screen
    @board.hide_guess(user_input)
    # @board_render_board
  end

  def check_win
    if match?
      puts "#{@current_player.name} got a match!"
      sleep_screen
      update_board_with_match
      update_player_score
      reset_round
    else
      puts 'No match!'
      # sleep_screen
      reset_round
    end
  end

  def match?
    prev_guess = @board.board[@prev_guess.first][@prev_guess.last].hidden_value
    current_guess = @board.board[@current_guess.first][@current_guess.last].hidden_value
    # debugger
    prev_guess == current_guess
  end

  def update_board_with_match
    @board.update_board(@prev_guess, @current_guess)
  end

  def win?
    @board.win?
  end
  
  def reset_round
    @current_guess = []
    @prev_guess = []
    @turn = 'first'

    if win? 
      clear_screen
      display_player_scores
      puts "\n"
      @board.render_board
      puts "\n"
      game_winner
      # puts "You won the game!" 
      if play_again?
        play_game
      else
        puts "See you next time!"
        sleep_screen
        exit
        return
      end
    else
      puts "Entering next round!"
    end
    
    sleep_screen
    switch_player
    prompt
  end

  def game_winner
    sorted_players = @players.sort_by do |player|
      player.score
    end

    if sorted_players.first.score == sorted_players.last.score
      puts "Tie game!"
    else
      winner = sorted_players.last
      puts "#{winner.name} wins!"
    end
    
  end

  def play_again?
    puts "Would you like to play again? (Y/N)"
    user_input = gets.chomp

    if valid_play_again?(user_input)
      if user_input == 'Y'
        return true
      elsif user_input == "N'"
        return false
      end
    else
      play_again?
    end
  end

  def valid_play_again?(input)
    ['Y', 'N'].include?(input)
  end
end


g = Game.new(Board.new)
g.play_game