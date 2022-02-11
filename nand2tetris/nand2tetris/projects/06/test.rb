r_answer = File.open(ARGV[0])
m_answer = File.open(ARGV[1])
puts r_answer.read
puts "\n"
puts m_answer.read
if r_answer.read == m_answer.read
  puts "T"
else
  puts "F"
end
