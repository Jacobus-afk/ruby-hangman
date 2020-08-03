# frozen_string_literal: true

require_relative 'file_handler.rb'

# class for all the different game functionality
class Game
  attr_reader :turns_left, :guessed_correctly, :dict_word
  def initialize
    @dictionary = DictionaryHandler.new('5desk.txt')
    @dict_word = @dictionary.guess_word
    @turns_left = 8
    @used_letters = []
    @correct_guessed_chars = []
    @guessed_correctly = false
    @unlocked_word = generate_word_dashes
    @guess = ''
  end

  def play_round
    system('cls') || system('clear')
    puts "Your word: #{@unlocked_word} \t\t"\
        "Turns left: #{@turns_left} \t\t"\
        "Used letters: #{@used_letters.join(',')}\n\n"
    acquire_guess
    handle_guess
  end

  private

  def acquire_guess
    loop do
      print 'Your guess? '
      @guess = gets.chomp.downcase
      next unless @guess =~ /[a-z]/

      next if @used_letters.include? @guess

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
