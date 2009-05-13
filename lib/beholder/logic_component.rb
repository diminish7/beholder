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
      raise MissingAttributeException.new("Missing 'condition' attribute in component:if") unless node.attributes.has_key?('condition')
      siblings = get_conditional_nodes(node)
      #Evaluate the 'if' clause
      found_truth = evaluate_conditional(node)
      #Evaluate (or short-circuit) the 'elsif' clauses
      siblings.each do |sibling|
        if sibling.attributes['component'] == 'elsif'
          found_truth ? sibling.parent.children.delete(sibling) : found_truth = evaluate_conditional(sibling)
        elsif sibling.attributes['component'] == 'else'
          found_truth ? sibling.parent.children.delete(sibling) : sibling.parent.replace_child(sibling, sibling.children)
          break #'Else' must be the last clause
        else
          raise "How did you get here?"
        end
      end
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
    
  protected
    #Considers the truth of the condition attribute, and either replaces the node with it's contents, or deletes the node
    def evaluate_conditional(node)
      condition = node.attributes['condition']
      if !(condition.nil? || condition == false || condition == "false")
        #True
        node.parent.replace_child(node, node.children)
        true
      else
        #False
        node.parent.children.delete(node)
        false
      end
    end
    
    #Get all related nodes in a conditional
    def get_conditional_nodes(if_node)
      siblings = []
      sibling = if_node.next_node
      sibling = sibling.next_node if empty_text_node?(sibling) #Skip whitespace text nodes
      while is_component?(sibling, 'elsif') do
        siblings << sibling
        sibling = sibling.next_node
        sibling = sibling.next_node if empty_text_node?(sibling)
      end
      siblings << sibling if is_component?(sibling, 'else')
      siblings
    end
    
    #Determine if a node has an attribute
    def is_component?(node, component)
      node && node.respond_to?(:attributes) && node.attributes['component'] == component
    end
    
    #Determine if a node is an empty text node (a text node with only whitespace)
    def empty_text_node?(node)
      node.kind_of?(Hpricot::Text) && node.to_s.strip.empty?
    end
    
  end
end