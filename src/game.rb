require 'literate_randomizer'
require_relative '../lib/monkey_patches.rb'
require_relative './snowman.rb'

class Game
  LOSER_IMG = 'imgs/you_lose.ascii-art'
  TITLE_IMG = 'imgs/title.ascii-art'

  def initialize(length: nil, difficulty: nil)
    @length = length
    @difficulty = difficulty
    render_title
    puts
    game_setup
  end

  def play
    until game_over?
      render_all
      check_guess(ask_for_guess)
    end

    if won?
      system('clear')
      render_title
      render_snowman
      render_word
      puts '    Congratulations! You win!'
    else
      system('clear')
      render_title
      render_loser_sun
      render_snowman(stripped: true)
    end
  end

  private

  def ask_for_guess
    puts '    Guess a letter:'
    gets.to_s.strip.first
  end

  def check_guess(guess)
    until !guess.nil? && !guess.empty? && !@previous_guesses.include?(guess)
      render_all
      puts '    Not a valid guess. Try again!'
      guess = ask_for_guess
    end

    @previous_guesses << guess
    if @secret_word.include?(guess)
      return reveal_letter(guess)
    end
    snowman.melt!
  end

  def game_over?
    won? || lost?
  end

  def game_setup
    request_difficulty if @difficulty.nil?
    request_length if @length.nil?
    @secret_word = generate_word
    @display_word = ['_'] * @length
    @previous_guesses = []
    snowman
  end

  def generate_word
    word = ''
    until word.length == @length && !word.include?('-')
      word = LiterateRandomizer.word.downcase
    end
    word.split('')
  end

  def handle_difficulty_input(input)
    case input
    when 'e'
      :easy
    when 'm'
      :medium
    when 'h'
      :hard
    when 'i'
      :impossible
    else
      puts "    I didn't recognize that input. Let's try again."
      nil
    end
  end

  def handle_length_input(input)
    length = input.to_i
    return 5 if length < 5
    return 18 if length > 18
    length
  end

  def lost?
    @snowman.melted?
  end

  def render_all
    reset_view
    render_title
    render_snowman
    render_word
    render_previous_guesses unless @previous_guesses.empty?
  end

  def render_loser_sun
    puts File.readlines(LOSER_IMG)
  end

  def render_previous_guesses
    puts '    Previous guesses: ' + @previous_guesses.sort.join(', ')
  end

  def render_snowman(stripped: false)
    snowman.render(stripped: stripped)
  end

  def render_title
    system('clear')
    puts File.readlines(TITLE_IMG)
    puts
  end

  def render_word
    puts
    puts "    " + @display_word.join(' ')
  end

  def request_difficulty
    until @difficulty
      puts '    What difficulty level would you like to try?'
      puts '    Choose from: (e)asy (m)edium (h)ard (i)mpossible'
      @difficulty = handle_difficulty_input(gets.strip.first)
    end
  end

  def request_length
    unless @length
      puts '    How long should the secret word be? (Between 5 and 18 characters)'
      @length = handle_length_input(gets.strip)
    end
  end

  def reset_view
    system('clear')
  end

  def reveal_letter(guess)
    @secret_word.each_with_index { |char, i| @display_word[i] = guess if char == guess }
  end

  def snowman
    @snowman ||= Snowman.new difficulty: @difficulty
  end

  def won?
    !@display_word.include?('_')
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new
  game.play
end