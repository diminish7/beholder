module Beholder
  module NodeUtils
    
    #Swaps the original node with a new node_set.  Returns the node_set
    def swap(orig, node_set)
      #TODO: Clean this up...
      replace_node = node_set.first
      orig.replace(replace_node)
      i = 1
      while i < node_set.length do
        replace_node.add_next_sibling(set[i])
        replace_node = node_set[i]
        i += 1
      end
      node_set
    end
    
  end
end