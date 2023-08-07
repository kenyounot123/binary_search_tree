class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data, left=nil, right=nil)
    @data = data
    @left = left
    @right = right
  end


end

class Tree
  attr_accessor :root, :array
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

  def insert(value)
    #takes that value compares it with root nodes
    #continues doing so until we get to a leaf node or until a root node has no children nodes
    new_node = Node.new(value)
    current_node = @root
    until current_node.left.nil? || current_node.right.nil?
      if new_node.data < current_node.data
        current_node = current_node.left
      else
        current_node = current_node.right
      end
    end
    if new_node.data < current_node.data
      current_node.left = new_node
    else
      current_node.right = new_node
    end
  end

  def delete(value, current_node=@root) #this assumes the value exists in the tree
    return current_node if current_node.nil?
    if value < current_node.data
      current_node.left = delete(value, current_node.left)
    elsif value > current_node.data
      current_node.right = delete(value, current_node.right)
    else
      # case 1 delete node with one child or none
      return current_node.right if current_node.left.nil?
      return current_node.left if current_node.right.nil?
      # case 3 delete node with two children 
      min_right_sub_tree = find_min(current_node.right)
      current_node.data = min_right_sub_tree.data
      current_node.right = delete(min_right_sub_tree.data, current_node.right)
    end
    current_node
  end

  def find_min(node)
    until node.left.nil?
      node = node.left
    end
    node
  end

  
end

my_tree = Tree.new([1,2,3,4,5,6,7,8,9])
my_tree.pretty_print
my_tree.insert(10)
my_tree.pretty_print
my_tree.delete(7)
my_tree.pretty_print



