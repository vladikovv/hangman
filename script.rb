require 'open-uri'

def generate_random_word
  words = []
  URI.open('words.txt').each do |word|
    words.push(word.chomp) if word.length >= 5 && word.length <= 12
  end
  words.sample
end


