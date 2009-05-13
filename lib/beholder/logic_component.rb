#Logic components for the parser
module Beholder
  class Parser
    
    #Replaces the node with text from the value attribute
    # Raises MissingAttributeException if value attribute is not present
    def _raw(node)
      raise MissingAttributeException.new("'value' attribute not present in component:raw") unless node.attributes.has_key?("value")
      node.swap node.attributes["value"]
    end
    
    #Replaces the node with the contents of the node
    def _yield(node)
      raise DependantComponentException.new("Cannot yield without a parent component") if @component_stack.empty? #Must have at least the yield component and a parent component
      parent = @component_stack.pop
      parent.attributes.each do |key, value|
        node.set_attribute(key, value) unless node.attributes[key] #Merge attributes with parent component's
      end
      node.parent.replace_child(node, parent.children)
    end
    
   
    #Replaces the node with its contents iff the value of the condition attribute is true
    # Raises MissingAttributeException if the condition attribute is not present
    def _if(node)
      
    end
    
    #Raises a DependantComponentException.  Should only be executed in the scope of an _if
    def _elsif(node)
      raise DependantComponentException.new("Cannot execute component:elsif outside of the context of component:if")
    end
    
    #Raises a DependantComponentException.  Should only be executed in the scope of an _if
    def _else(node)
      raise DependantComponentException.new("Cannot execute component:else outside of the context of component:if")
    end
    
    #Iterates over the collection found in the enumerable attribute, and yields
    # the current iteration's object to the object attribute, and the current 
    # iteration's counter to the counter attribute.
    # Raises MissingAttributeException if enumerable is not present
    # The enumerable attribute must be enumerable
    def _foreach(node)
      
    end
    
    #Iterates for a count specified by the count attribute, and yields the current
    # iteration's counter to the counter attribute.
    # Raises MissingAttributeException if count is not present
    def _count(node)
      
    end
    
  end
end