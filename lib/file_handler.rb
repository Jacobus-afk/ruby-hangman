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
  # attr_reader :guess_word
  attr_accessor :guess_word
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
    word.downcase
  end
end

# class to handle save files
class SaveFileHandler < FileHandler
  attr_reader :saved_game
  def initialize
    @saved_game = nil
    Dir.mkdir(SAVEPATH) unless Dir.exist? SAVEPATH
    print 'Load a save file (Y/N)? '
    load_game if gets.chomp.downcase == 'y'
  end

  def save_game(game)
    system('cls') || system('clear')
    print 'Name for save file? '
    filename = gets.chomp.downcase + '.yml'
    # test = YAML.dump(game.to_h)
    File.open(SAVEPATH + filename, 'w') { |file| file.write(game.to_yaml) }
    puts 'Game saved.. Press Enter'
    gets
  end

  private

  def load_game
    save_files = Dir.entries(SAVEPATH).filter_map { |file| file.split('.').first unless File.directory? file }
    puts "List of save_files: #{save_files}"
    loop do
      print 'Please type in the name of your save file: '
      save_selection = gets.chomp.downcase
      return read_file(save_selection) if save_files.include? save_selection

      puts 'Invalid save file name'
    end
  end

  def read_file(save_selection)
    @saved_game = YAML.load(File.read(SAVEPATH + save_selection + '.yml'))
  end
end
