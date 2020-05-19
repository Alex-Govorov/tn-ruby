puts 'Ваше имя?'
name = gets.chomp

puts 'Ваш рост?'
height = gets.chomp.to_i

ideal_weight = (height - 110) * 1.15

if ideal_weight.negative?
  puts "#{name}, ваш вес уже оптимальный"
else
  puts "#{name}, ваш идеальный вес: #{ideal_weight}"
end
