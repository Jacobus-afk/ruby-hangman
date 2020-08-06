# frozen_string_literal: true

require_relative 'game.rb'

game = Game.new

game.play_round until game.turns_left <= 0

if game.guessed_correctly
  puts "\nCongrats, guessed #{game.dict_word} correctly!"
else
  puts "\nYou lost, ran out of turns. Word was #{game.dict_word}"
end
