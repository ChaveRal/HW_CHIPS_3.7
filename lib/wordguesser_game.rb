require 'sinatra'
require 'sinatra/flash'

class WordGuesserGame
  attr_reader :word, :incorrect_guesses

  def initialize(word)
    @word = word.downcase
    @correct_guesses = []
    @incorrect_guesses = []
  end

  def self.get_random_word
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body.downcase
    }
  end

  def guess?(letter)
    letter = letter.downcase
    if @word.include?(letter)
      @correct_guesses << letter
      return true
    else
      @incorrect_guesses << letter
      return false
    end
  end

  def word_with_guesses
    display_word = @word.chars.map do |char|
      @correct_guesses.include?(char) ? char : '-'
    end
    display_word.join('')
  end
def check_win
    (Set.new(@word.chars) - Set.new(@correct_guesses)).empty?
  end

  def check_lose
    @incorrect_guesses.length >= 7
  end
end
