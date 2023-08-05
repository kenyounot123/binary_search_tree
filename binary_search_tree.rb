class Node
  include Comparable
  attr_accessor :data, :left, :right
  def <=>(other)
    self.data <=> other.data
  end
  def initialize(data, left=nil, right=nil)
    @data = data
    @left = left
    @right = right
  end


end

class Tree
  def initialize(array)
    @array = array.uniq.sort
    @root = build_tree(@array)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def build_tree(array) 
  
    return nil if array.empty? 
    array_start = 0
    array_end = array.length - 1
    middle = (array_start + array_end) / 2

    root_node = Node.new(array[middle])
    root_node.left = build_tree(array[array_start...middle])
    root_node.right = build_tree(array[(middle + 1)..array_end])

    root_node
  end
  

end

my_tree = Tree.new([1,2,3,4,5,6,7,8,9])
my_tree.pretty_print