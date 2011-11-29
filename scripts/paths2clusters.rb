DESCRIPTION = "Reads a `.paths` file output by Percy Liang's `wcluster` and produces a YAML-encoded list of clusters"

USAGE = "ruby #{$0} file.path > file.yaml"
NUM_ARGS = 1

if ARGV.size != NUM_ARGS
  STDERR.puts DESCRIPTION
  STDERR.puts " "
  STDERR.puts "Usage: #{USAGE}"
  exit(1)
end

paths = ARGV.shift

clusters = {}
IO.foreach(paths) do |line|
  path, word, count = line.strip.split(/\s+/)
  clusters[path] ||= []
  clusters[path].push word
end

puts clusters.to_yaml