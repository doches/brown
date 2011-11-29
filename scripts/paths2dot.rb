DESCRIPTION = "Reads a `.paths` file output by Percy Liang's `wcluster` and produces a GraphViz-friendly .dot representation of the encoded hierarchy"

USAGE = "ruby #{$0} file.path > file.dot"
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

@nodes = {}
def get_node(prefix)
  if @nodes[prefix].nil?
    @nodes[prefix] = "INTERNAL#{@nodes.size}"
    puts "\t#{@nodes[prefix]} [shape=\"none\", label=\"\"];"
  end
  return @nodes[prefix]
end

@edges = {}
def print_edge(from,to)
  key = "#{from}_#{to}"
  if @edges[key].nil?
    puts "\t#{from} -> #{to};"
    @edges[key] = true
  end
end

@leaves = {}
def get_leaf(word)
  if @leaves[word].nil?
    @leaves[word] = "LEAF#{@leaves.size}"
    puts "\t#{@leaves[word]} [label=\"#{word}\"];"
  end
  return @leaves[word]
end

puts "digraph {"
@nodes[""] = "INTERNAL0"
puts "\tINTERNAL0 [shape=\"none\", label=\"\"];"
clusters.each_pair do |path,words|
  (0..path.size-1).each do |prefix_len|
    prefix = path[0..prefix_len]
    parent_prefix = prefix_len > 0 ? path[0..(prefix_len)-1] : ""
    
    parent = get_node(parent_prefix)
    node = get_node(prefix)
    
    print_edge(parent,node)
  end
  
  words.each do |word|
    print_edge(get_node(path),get_leaf(word))
  end
end
puts "}"