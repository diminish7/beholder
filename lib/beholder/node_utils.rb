module Beholder
  module NodeUtils
    
    #Swaps the original node with a new node_set.  Returns the node_set
    def swap(orig, node_set)
      #TODO: Clean this up...
      replace_node = node_set.first
      orig.replace(replace_node)
      i = 1
      while i < node_set.length do
        replace_node.add_next_sibling(node_set[i])
        replace_node = node_set[i]
        i += 1
      end
      @removed << orig
      node_set
    end
    
    def remove(node)
      @removed << node.remove unless node.nil?
    end
    
    def removed?(node)
      @removed.include?(node)
    end
    
  end
end