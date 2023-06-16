require 'open-uri'
require 'json'

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

  def as_json(options={})
    {
      word: @word,
      incorrect_guesses_count: @incorrect_guesses_count,
      max_incorrect_guesses: @max_incorrect_guesses,
      correct_guesses_count: @correct_guesses_count,
      correct_letters: @correct_letters,
      attempts_count: @attempts_count
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
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

def lost_game_print(game)
  print "You sadly lost the game :( ...........\n"
  sleep(1)
  print "You guessed #{game.correct_guesses_count} letters correctly ..........\n"
  sleep(2)
  print "The word in question was #{game.word}......\n\n"
  sleep(5)
  print "Going to main menu .....\n\n\n"
  sleep(2)
end

def won_game_print(game)
  print "You guessed it!!! NICe!\n"
  sleep(1)
  print "It took you #{game.correct_guesses_count + game.incorrect_guesses_count} guesses to finish!\n"
  sleep(3)
  print "Going to main menu!\n\n\n"
  sleep(2)
end

def guess_input_prompt(game)
  sleep(0.5)
  print "You have #{game.max_incorrect_guesses - game.incorrect_guesses_count} guesses remaining.\n\n"
  sleep(0.5)
  print "Guess the letters the word contains!\n"
  sleep(0.5)
  print 'Input a single letter: '
  sleep(1)
end

def correct_guess_print
  print 'CORRECT!'
  sleep(1)
end

def incorrect_guess_print
  print "sike.....\n"
  sleep(1)
  print 'maybe next time..'
end

def save_game(game)
  File.open('game.json', 'w') { |f| f.write(game.to_json) }
end

def start_game(command)
  game = Game.new
  return game if command == 'new'

  struct_obj = JSON.parse(File.read('game.json'), object_class: OpenStruct)
  game.word = struct_obj.table[:word]
  game.attempts_count= struct_obj.table[:attempts_count]
  game.correct_guesses_count = struct_obj.table[:correct_guesses_count]
  game.correct_letters = struct_obj.table[:correct_letters]
  game.incorrect_guesses_count = struct_obj.table[:incorrect_guesses_count]
  game
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
  print("Input 'new' to start a new game!\n")
  sleep(1)
  print("Input 'load' to load a previously saved game~!\n\n")
  sleep(1)

  print('Your input: ')
  start_command = gets.chomp
  while start_command != 'new' && start_command != 'load'
    print('Your input: ')
    start_command = gets.chomp
  end

  game = start_game(start_command)
  # p game.word
  print "\nGame loaded!\n\n"
  sleep(2)
  game_over = false
  until game_over
    sleep(1)
    print "TURN #{game.attempts_count + 1}\n\n"
    sleep(1)
    print "Save game? (input 'y' to save, 'n' to continue): "
    save_command = gets.chomp
    while save_command != 'y' && save_command != 'n'
      print('Your input: ')
      save_command = gets.chomp
    end
    save_game(game) if save_command == 'y'

    print_newlines_and_sleep(0.5)
    game.print_correct_guessed_letters
    guess_input_prompt(game)
    guess = gets.chomp
    until guess.length == 1
      sleep(0.5)
      print 'Input a SINGLE letter: '
      guess = gets.chomp
    end
    print_newlines_and_sleep(1)

    if game.guess(guess)
      correct_guess_print
    else
      incorrect_guess_print
    end

    2.times do
      print_newlines_and_sleep(0.5)
    end
    sleep(0.5)
    game.print_correct_guessed_letters
    print("\n")
    game_over = game_lose?(game) || game_win?(game)
    if game_lose?(game)
      lost_game_print(game)
      main_menu
    elsif game_win?(game)
      won_game_print(game)
      main_menu
    end
    print '-----------------------------'
    print_newlines_and_sleep(0.5)
    print_newlines_and_sleep(0.5)
  end
end

main_menu
