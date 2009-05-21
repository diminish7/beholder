#Logic components for the parser
module Beholder
  module LogicComponent
    include NodeUtils
    
    #Replaces the node with text from the value attribute
    # Raises MissingAttributeException if value attribute is not present
    def _raw(node)
      raise MissingAttributeException.new("'value' attribute not present in component:raw") unless node.attributes.has_key?("value")
      swap(node, Nokogiri::HTML.fragment(node.attributes["value"].to_s).children)
    end
    
    #Replaces the node with the contents of the node
    def _yield(node)
      raise DependantComponentException.new("Cannot yield without a parent component") if @component_stack.empty? #Must have at least the yield component and a parent component
      parent = @component_stack.pop
      parent.attributes.each do |key, value|
        node.set_attribute(key, value) unless node.attributes[key] #Merge attributes with parent component's
      end
      swap(node, parent.children)
    end
    
   
    #Replaces the node with its contents iff the value of the condition attribute is true
    # Raises MissingAttributeException if the condition attribute is not present
    def _if(node)
      raise MissingAttributeException.new("Missing 'condition' attribute in component:if") unless node.attributes.has_key?('condition')
      siblings = get_conditional_nodes(node)
      node_set = nil
      #Evaluate the 'if' clause
      node_set = evaluate_conditional(node)
      #Evaluate (or short-circuit) the 'elsif' clauses
      siblings.each do |sibling|
        if is_component?(sibling, 'elsif')
          node_set ? remove(sibling) : node_set = evaluate_conditional(sibling)
        elsif is_component?(sibling, 'else')
          node_set ? remove(sibling) : node_set = swap(sibling, sibling.children)
          break #'Else' must be the last clause
        else
          raise "How did you get here?"
        end
      end
      node_set || []
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
      raise MissingAttributeException.new("Missing 'count' attribute in component:count") unless node.attributes.has_key?('count')
      body_html = node.children.to_s
      body = nil
      node.attributes['count'].to_s.to_i.times do |i|
        iter_body = Nokogiri::HTML.fragment(body_html).children
        #TODO: This get's evaluated twice now, becuase it gets evaluated in resolve_as_component
        iter_body.each { |child| evaluate(child, {:count => i}) }
        if body
          iter_body.each { |child| body.after(child) }
        else
          body = iter_body
        end
      end
      swap(node, body)
    end
    
  protected
    #Considers the truth of the condition attribute, and either replaces the node with it's contents, or deletes the node
    def evaluate_conditional(node)
      condition = node.attributes['condition'].to_s
      if !(condition.nil? || condition == "false")
        #True
        swap(node, node.children)
      else
        #False
        remove(node)
        nil
      end
    end
    
    #Get all related nodes in a conditional
    def get_conditional_nodes(if_node)
      siblings = []
      sibling = if_node.next
      sibling = sibling.next if empty_text_node?(sibling) #Skip whitespace text nodes
      while is_component?(sibling, 'elsif') do
        siblings << sibling
        sibling = sibling.next
        sibling = sibling.next if empty_text_node?(sibling)
      end
      siblings << sibling if is_component?(sibling, 'else')
      siblings
    end
    
    #Determine if a node has an attribute
    def is_component?(node, component)
      node && node.respond_to?(:attributes) && node.attributes['component'].to_s == component
    end
    
    #Determine if a node is an empty text node (a text node with only whitespace)
    def empty_text_node?(node)
      node.kind_of?(Nokogiri::XML::Text) && node.to_s.strip.empty?
    end
    
  end
end