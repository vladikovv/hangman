require 'open-uri'

class Game
  def initialize
    @word = generate_random_word
    @max_incorrect_guesses = 10
    @correct_guesses = 0
  end

  def generate_random_word
    words = []
    URI.open('words.txt').each do |word|
      words.push(word.chomp) if word.length >= 5 && word.length <= 12
    end
    words.sample
  end
end