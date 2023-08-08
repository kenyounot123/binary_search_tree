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

  def find(value, current_node=@root) #returns node with the given value
    return current_node if current_node.nil?
    if value < current_node.data
      find(value, current_node.left)
    elsif value > current_node.data
      find(value, current_node.right)
    else
      return current_node
    end
  end

  def find_min(node) #used to delete a node with two childred
    until node.left.nil?
      node = node.left
    end
    node
  end

  def level_order(current_node=@root) #traverse the tree in breadth-first level order and yield each node to provided block
    return nil if current_node.nil?
    queue_values = []
    queue_values.push(current_node)
    while !queue_values.empty?
      return queue_values unless block_given?
      current_node = queue_values.first
      yield(current_node)
      queue_values.push(current_node.left) unless current_node.left.nil?
      queue_values.push(current_node.right) unless current_node.right.nil?
      queue_values.shift
    end
  end

  def inorder(current_node=@root) #left, root, right
    array_values = []
    return nil if current_node.nil?
    inorder(current_node.left)
    return array_values unless block_given?
    yield(current_node)
    inorder(current_node.right)

  end

  def preorder(current_node=@root)   #root, left, right
    array_values = []
    return nil if current_node.nil?
    return array_values unless block_given?
    array_values.push(current_node)
    yield(current_node)
    preorder(current_node.left)
    preorder(current_node.right)

  end

  def postorder(current_node=@root) #left, right, root
    array_values = []
    return nil if current_node.nil?
    postorder(current_node.left)
    postorder(current_node.right)
    return array_values unless block_given?
    array_values.push(current_node) 
    yield(current_node)
  end

  def height(node) #method which accepts a node and returns its height.
    current_node = @root
    edges = 0
    until current_node.data == node.data
      if node.data < current_node.data
        current_node = current_node.left
      elsif node.data > current_node.data
        current_node = current_node.right
      else
        
    end

  end

  
end

my_tree = Tree.new([1,2,3,4,5,6,7,8,9])
my_tree.pretty_print
my_tree.insert(10)
my_tree.pretty_print
my_tree.delete(7)
my_tree.pretty_print
p my_tree.find(3)




