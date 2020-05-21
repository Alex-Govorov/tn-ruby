letters = ('a'..'z').to_a
vowels = 'aeiouy'
h = {}
letters.each_with_index { |l, i| h[l] = i + 1 if vowels.include?(l) }
