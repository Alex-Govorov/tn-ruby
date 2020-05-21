puts 'Введите день:'
d = gets.chomp.to_i

puts 'Введите месяц:'
m = gets.chomp.to_i

puts 'Введите год:'
y = gets.chomp.to_i

md = { 1 => 31, 2 => 28, 3 => 31, 4 => 30, 5 => 31, 6 => 30, 7 => 31, 8 => 31, 9 => 30,
       10 => 31, 11 => 30, 12 => 31 }

md[2] = 29 if (y % 4).zero? || ((y % 100).zero? && (y % 400).zero?)

md.each { |month, days| d += days if month < m }

puts "Порядковый номеры даты: #{d}"
