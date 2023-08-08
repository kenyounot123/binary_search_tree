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

  def insert(value, node=@root) 
    return @root = Node.new(value) if @root.nil?
    return Node.new(value) if node.nil?
    value < node.data ? node.left = insert(value, node.left) : node.right = insert(value, node.right)
    node
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
    queue = []
    queue.push(current_node)
    while !queue.empty?
      return queue unless block_given?
      current_node = queue.first
      yield(current_node)
      queue.push(current_node.left) unless current_node.left.nil?
      queue.push(current_node.right) unless current_node.right.nil?
      queue.shift
    end
  end

  def inorder(current_node=@root,output=[]) #left, root, right
    return nil if current_node.nil?
    inorder(current_node.left, output)
    output.push(block_given? ? yield(current_node) : current_node.data) 
    inorder(current_node.right, output)
    output
  end

  def preorder(current_node=@root, output=[])   #root, left, right
    return nil if current_node.nil?
    output.push(block_given? ? yield(current_node) : current_node.data) 
    preorder(current_node.left, output)
    preorder(current_node.right, output)
    output
  end

  def postorder(current_node=@root, output=[]) #left, right, root
    return nil if current_node.nil?
    postorder(current_node.left, output)
    postorder(current_node.right, output)
    output.push(block_given? ? yield(current_node) : current_node.data) 
    output
  end

  def height(node,edges=0) #method which accepts a node and returns its height. Height defined as number of edges from given node to leaf node
    #find height of left subtree, find height of right subtree,
    #return the max of this.
    return 0 if node.nil?
    return edges if node.left.nil? && node.right.nil?
    left_subtree = height(node.left, edges + 1)
    right_subtree = height(node.right, edges + 1)
    return [left_subtree, right_subtree].max
  end

  def depth(node, depth=0) #method which accepts a node and returns its depth. Depth defined as number of edges from given node to root node
    return 0 if node.nil?
    current_node = @root
    until current_node.data == node.data
      if node.data < current_node.data
        current_node = current_node.left
        depth += 1
      elsif node.data > current_node.data
        current_node = current_node.right
        depth += 1
      end
    end
    depth
  end


  def balanced? #checks if the tree is balanced.  A balanced tree is one where the difference between heights of left subtree and right subtree of every node is not more than 1.
    self.level_order do |node|
      left_subtree_height = height(node.left)
      right_subtree_height = height(node.right)
      unless (left_subtree_height - right_subtree_height).abs <= 1
        return false
      end
    end
    return true
  end

  def rebalance #method which rebalances an unbalanced tree
    return if self.balanced?
    array_of_values = self.inorder
    @root = build_tree(array_of_values)
  end

  
end

#driver script
new_tree = Tree.new((Array.new(15) {rand(1..100)}))
puts "Tree is balanced: #{new_tree.balanced?}"
puts "Inorder traversal: #{new_tree.inorder}"
puts "Level-order traversal: #{new_tree.level_order}"
puts "Post-order traversal: #{new_tree.postorder}"
puts "Pre-order traversal: #{new_tree.preorder}"
new_tree.pretty_print
10.times do
  add_numbers = rand(100..500)
  puts "Adding #{add_numbers} to tree..."
  new_tree.insert(add_numbers)
end
new_tree.pretty_print
puts "Tree is balanced: #{new_tree.balanced?}"
new_tree.rebalance
puts "Rebalancing tree..."
new_tree.pretty_print
puts "Tree is balanced: #{new_tree.balanced?}"
puts "Inorder traversal: #{new_tree.inorder}"
puts "Level-order traversal: #{new_tree.level_order}"
puts "Post-order traversal: #{new_tree.postorder}"
puts "Pre-order traversal: #{new_tree.preorder}"






