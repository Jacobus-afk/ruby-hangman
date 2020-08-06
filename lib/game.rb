# frozen_string_literal: true

require_relative 'file_handler.rb'

# class for all the different game functionality
class Game
  attr_reader :turns_left, :guessed_correctly, :dict_word, :used_letters, :correct_guessed_chars, :unlocked_word, :guess
  def initialize
    @saver = SaveFileHandler.new
    @dictionary = DictionaryHandler.new('5desk.txt')

    if @saver.saved_game
      load_saved_game
    else
      load_defaults
    end
    # @dict_word = @dictionary.guess_word
    # @turns_left = 8
    # @used_letters = []
    # @correct_guessed_chars = []
    # @guessed_correctly = false
    # @unlocked_word = generate_word_dashes
    # @guess = ''
  end

  def play_round
    system('cls') || system('clear')
    puts "Your word: #{@unlocked_word} \t\t"\
        "Turns left: #{@turns_left} \t"\
        "Used letters: #{@used_letters.join(',')}\t\t"\
        "Press \` to save game, ESC to exit \n\n"
    acquire_guess
    handle_guess
  end

  private

  def load_defaults
    @dict_word = @dictionary.guess_word
    @turns_left = 8
    @used_letters = []
    @correct_guessed_chars = []
    @guessed_correctly = false
    @unlocked_word = generate_word_dashes
    @guess = ''
  end

  def load_saved_game
    # @dictionary = DictionaryHandler.new('5desk.txt')
    @dictionary.guess_word = @saver.saved_game.dict_word
    @dict_word = @saver.saved_game.dict_word
    @turns_left = @saver.saved_game.turns_left
    @used_letters = @saver.saved_game.used_letters
    @correct_guessed_chars = @saver.saved_game.correct_guessed_chars
    @guessed_correctly = @saver.saved_game.guessed_correctly
    @unlocked_word = @saver.saved_game.unlocked_word
    @guess = @saver.saved_game.guess
  end

  def handle_input
    system('stty raw -echo') #=> Raw mode, no echo
    @guess = STDIN.getc
    system('stty -raw echo') #=> Reset terminal mode
    return @saver.save_game(self) if @guess == "\`"

    return @turns_left = 0 if @guess.ord == 27

    true if (@guess =~ /[a-z]/) && !@used_letters.include?(@guess)
  end

  def acquire_guess
    loop do
      print 'Your guess? '
      # https://stackoverflow.com/questions/946738/detect-key-press-non-blocking-w-o-getc-gets-in-ruby/22659929
      break if handle_input == true

      # @guess = gets.chomp.downcase
      # next unless @guess =~ /[a-z]/

      # next if @used_letters.include? @guess

      return
    end
  end

  def handle_guess
    @used_letters << @guess
    if @dict_word.include? @guess
      @correct_guessed_chars << @guess
    else
      @turns_left -= 1
    end
    # https://stackoverflow.com/questions/56504584/how-to-replace-matching-characters-in-a-string-ruby/56505259#56505259
    @unlocked_word = @dict_word.chars.map { |char| @correct_guessed_chars.include?(char) ? char : '_' }.join

    return if @unlocked_word.include? '_'

    @guessed_correctly = true
    @turns_left = 0
  end

  def generate_word_dashes
    '_' * @dict_word.length
  end
end
