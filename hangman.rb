def validate letter
  return false if letter.length != 1
  bob = letter =~ /[A-Za-z]/
  return true if bob != nil
  false
end

def check letter, word
  results = []
  i = 0
  while i < word.length
    results << i if word[i] == letter
    i += 1
  end
  results
end

def edit letters, guess_word, word
  letters.each do |i|
  guess_word[i] = word[i]
  end
  guess_word
end

def victory? guess_word
  i = 0
  while i < guess_word.length
    return false if guess_word[i] == '_'
    i += 1
  end
  true
end

game_type = ''
while game_type != 'n' && game_type != 'l'
  print "type n for new game or l for load game: "
  game_type = gets.chomp
  game_type = game_type.downcase
end

if game_type == 'n'
  dictionary = File.open("dictionary.txt", "r")
  words = dictionary.read
  dictionary.close
  words = words.split
  hangman_words = []
  i = 0
  while i < words.size
    hangman_words << words[i] if words[i].length >= 5 && words[i].length <= 12
    i += 1
  end
  word = hangman_words[rand(hangman_words.size)]
  word = word.downcase
  guess_word = ""
  i = 0
  while i < word.length
    guess_word << '_'
    i += 1
  end
  guesses = 5
  letters_chosen = ""
else
  file = File.open("save.txt", "r")
  guesses = file.readline.to_i
  word = file.readline
  guess_word = file.readline
  letters_chosen = file.readline
  file.close
end

while guesses > 0
  puts "your word is: #{guess_word}"
  puts "you have #{guesses} incorrect guess#{'es' if guesses > 1} remaining."
  puts "you have already guessed these letters: #{letters_chosen}"
  ok = false
  letter = nil
  while !ok
    print "guess a letter, or type save to save your game: "
    letter = gets.chomp
    letter = letter.downcase
    if letter == 'save'
      break
    end
    ok = validate letter
    puts "invalid entry" if !ok
  end
  if letter == 'save'
    savefile = File.open("save.txt", "w")
    savefile.puts guesses
    savefile.puts word
    savefile.puts guess_word
    savefile.puts letters_chosen
    savefile.close
    break
  end
  letters_chosen << letter
  letters = check letter, word
  guess_word = edit letters, guess_word, word
  if victory? guess_word
    puts "you got it!"
    puts "The word was #{word}."
    guesses = -1
  else
    guesses -= 1 if letters.empty?
    if guesses == 0
      puts "You are out of guesses."
      puts "The word was #{word}."
    end
  end

end
