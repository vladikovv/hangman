require 'open-uri'

class Game
  attr_accessor :word, :correct_guesses, :correct_letters

  def initialize
    @word = generate_random_word
    @max_incorrect_guesses = 10
    @correct_guesses = 0
    @correct_letters = []
  end

  def generate_random_word
    words = []
    URI.open('words.txt').each do |word|
      words.push(word.chomp) if word.length >= 5 && word.length <= 12
    end
    words.sample
  end

  def guess(letter)
    letter.downcase!
    if word.include?(letter)
      @correct_guesses += 1
      correct_letters.push(letter)
    end
  end
end

game = Game.new
game.guess("X")