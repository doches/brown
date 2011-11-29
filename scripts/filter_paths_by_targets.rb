DESCRIPTION = "Takes a `.paths` file and a list of target words (either a yamlised cluster or a flat list) and outputs a version of the paths file which only includes the specified targets"

USAGE = "ruby #{$0} file.paths targets.(txt|yaml) > filtered.paths"
NUM_ARGS = 2

if ARGV.size != NUM_ARGS
  STDERR.puts DESCRIPTION
  STDERR.puts " "
  STDERR.puts "Usage: #{USAGE}"
  exit(1)
end

paths = ARGV.shift
targets = ARGV.shift

if targets =~ /yaml$/
  targets = YAML.load_file(targets).keys.uniq.map { |x| x.to_sym }
else
  targets = IO.readlines(targets).map { |x| x.strip }.uniq.map { |x| x.to_sym }
end

IO.foreach(paths) do |line|
  prefix,word,count = *(line.strip.split(/\s+/))
  puts line.strip if targets.include?(word.to_sym)
end