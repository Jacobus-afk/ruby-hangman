# frozen_string_literal: true

require 'English'

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
end
