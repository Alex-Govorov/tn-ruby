letters = ('a'..'z').to_a
vowels = 'aeiouy'
h = {}
letters.each_with_index { |letter, index| h[letter] = index + 1 if vowels.include?(letter) }
