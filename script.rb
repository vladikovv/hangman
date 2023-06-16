require 'open-uri'

class Game
  attr_accessor :word, :correct_guesses, :correct_letters, :incorrect_guesses

  def initialize
    @word = generate_random_word
    @incorrect_guesses = 0
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
    else
      @incorrect_guesses += 1
    end
  end

  def print_correct_guessed_letters
    word.split('').each do |letter|
      if correct_letters.include?(letter)
        print "#{letter} "
      else
        print '_ '
      end
    end
    print "\n"
  end
end

def game_loop
  game = Game.new
  p game.word
  game.print_correct_guessed_letters
  while game.incorrect_guesses < 7
    print "Guess the letters the word contains!\nInput a single letter: "
    guess = gets.chomp
    until guess.length == 1
      print 'Input a SINGLE letter: '
      guess = gets.chomp
    end
    game.guess(guess)
    game.print_correct_guessed_letters
  end
end

game_loop
