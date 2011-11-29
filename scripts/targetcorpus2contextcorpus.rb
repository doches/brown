DESCRIPTION = "Reads a corpus of the format `target_word c1 c2 c3 .. cN` and outputs one of the format `c1 c2 c3 target_word c4 c5 c6`"

USAGE = "ruby #{$0} file.target_corpus > file.context_corpus"
NUM_ARGS = 1

if ARGV.size != NUM_ARGS
  STDERR.puts DESCRIPTION
  STDERR.puts " "
  STDERR.puts "Usage: #{USAGE}"
  exit(1)
end

corpus = ARGV.shift

IO.foreach(corpus) do |line|
  words = line.split(/\s+/)
  target = words.shift
  puts [words[0..words.size/2-1], target, words[words.size/2..words.size]].flatten.join(" ")
end