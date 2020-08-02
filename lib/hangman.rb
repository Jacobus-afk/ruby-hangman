# frozen_string_literal: true

require_relative 'file_handler.rb'

dictionary = DictionaryHandler.new('5desk.txt')

puts dictionary.guess_word
