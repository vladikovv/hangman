require 'open-uri'

class Game
  attr_accessor :word, :correct_guesses_count, :correct_letters, :incorrect_guesses_count, :attempts_count
  attr_reader :max_incorrect_guesses

  def initialize
    @word = generate_random_word
    @incorrect_guesses_count = 0
    @max_incorrect_guesses = 7
    @correct_guesses_count = 0
    @correct_letters = []
    @attempts_count = 0
  end

  def generate_random_word
    words = []
    URI.open('words.txt').each do |word|
      word.chomp!
      words.push(word) if word.length >= 5 && word.length <= 12
    end
    words.sample
  end

  def guess(letter)
    letter.downcase!
    letter_count_in_word = word.count(letter)
    @attempts_count += 1
    if word.include?(letter) && !correct_letters.include?(letter)
      @correct_guesses_count += letter_count_in_word
      correct_letters.push(letter)
      true
    else
      @incorrect_guesses_count += 1
      false
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

  def self.print_instructions
    print "You need to guess all the letters in a randomly generated word.\n"
    sleep(2)
    print "In the beginning you'll get a cue about the word's length.\n"
    sleep(2)
    print "If you guess a letter correctly you will see its position in the word.\n"
    sleep(3)
    print "The word (along with the missing letters) will be printed after each guess.\n"
    sleep(3)
    print "You can hit a maximum of 7 incorrect guesses before the game ends.\n"
    sleep(2)
    print "Good luck!\n\n"
    sleep(2)
  end
end

def print_newlines_and_sleep(seconds)
  print("\n")
  sleep(seconds)
end

def game_lose?(game)
  game.incorrect_guesses_count >= 7
end

def game_win?(game)
  game.correct_letters.length == game.word.split('').uniq.length
end

def main_menu
  print("H A N G M A N\n\n")
  sleep(2)
  print("Input 'play' to start a game!\n")
  sleep(1)
  print("Input 'help' to see the game's instructions!\n")
  sleep(1)
  print("Input 'quit' to quit (obviously)\n\n")
  sleep(1)
  print('Your input: ')

  command = gets.chomp
  while command != 'play' && command != 'help' && command != 'quit'
    print('Your input: ')
    command = gets.chomp
  end

  case command
  when 'play'
    print_newlines_and_sleep(0.5)
    print_newlines_and_sleep(0.5)
    print_newlines_and_sleep(2)
    play
  when 'help'
    print_newlines_and_sleep(0.5)
    print_newlines_and_sleep(0.5)
    print_newlines_and_sleep(2)
    Game.print_instructions
    main_menu
  when 'quit'
    sleep(1)
    print "nice knowing ya buhbye\n"
    sleep(2)
    exit
  end
end

def play
  game = Game.new
  #p game.word
  game.print_correct_guessed_letters
  game_over = false
  until game_over
    sleep(0.5)
    print "You have #{game.max_incorrect_guesses - game.incorrect_guesses_count} guesses remaining.\n\n"
    sleep(0.5)
    print "Guess the letters the word contains!\n"
    sleep(0.5)
    print "Input a single letter: "
    sleep(1)
    guess = gets.chomp
    until guess.length == 1
      sleep(0.5)
      print 'Input a SINGLE letter: '
      guess = gets.chomp
    end
    print "\n"
    sleep(1)
    if game.guess(guess)
      print "CORRECT!"
      sleep(1)
    else
      print "sike.....\n"
      sleep(1)
      print "maybe next time.."
    end
    2.times do
      print_newlines_and_sleep(0.5)
    end
    sleep(0.5)
    game.print_correct_guessed_letters
    print("\n")
    game_over = game_lose?(game) || game_win?(game)
    if game_lose?(game)
      print "You sadly lost the game :( ...........\n"
      sleep(1)
      print "You guessed #{game.correct_guesses_count} letters correctly ..........\n"
      sleep(2)
      print "The word in question was #{game.word}......\n\n"
      sleep(5)

      print "Going to main menu .....\n\n\n"
      sleep(2)
      main_menu
    elsif game_win?(game)
      print "You guessed it!!! NICe!\n"
      sleep(1)
      print "It took you #{game.correct_guesses_count + game.incorrect_guesses_count} guesses to finish!\n"
      sleep(3)
      print "Going to main menu!\n\n\n"
      sleep(2)
      main_menu
    end
  end
end

main_menu
