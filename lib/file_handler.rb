# frozen_string_literal: true

SAVEPATH = 'saves/'

require 'English'
require 'yaml'
# class to handle file ops
class FileHandler
  def initialize(filename)
    @raw_file = File.open(filename, 'r')
    # https://stackoverflow.com/questions/2650517/count-the-number-of-lines-in-a-file-without-reading-entire-file-into-memory
    @line_count = `wc -l < "#{filename}"`.to_i
  end
end

# class to handle dictionary
class DictionaryHandler < FileHandler
  attr_reader :guess_word
  def initialize(filename)
    super(filename)
    @guess_word = generate_word
  end

  def generate_word
    word = ''
    until word.length > 4 && word.length < 13
      @raw_file.rewind
      rand(@line_count).times { @raw_file.gets }
      word = $LAST_READ_LINE.chomp
    end
    word
  end
end

# class to handle save files
class SaveFileHandler < FileHandler
  def initialize
    puts
  end

  def save_game(game)
    Dir.mkdir(SAVEPATH) unless Dir.exist? SAVEPATH
    system('cls') || system('clear')
    print 'Name for savefile? '
    filename = gets.chomp + '.yml'
    # test = YAML.dump(game.to_h)
    File.open(SAVEPATH + filename, 'w') { |file| file.write(game.to_yaml) }
    puts 'Game saved.. Press Enter'
    gets
  end
end
