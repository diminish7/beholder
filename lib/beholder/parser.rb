module Beholder
  class Parser
    
    #Parses a template and returns the full HTML string
    def parse(template)
      raise TemplateNotFoundException.new(template) unless File.exist?(template)
      html = open(template) { |f| Hpricot(f) }
      evaluate(html)
      html.to_s
    end
    
  private
    #Evaluate a node recursively
    # TODO: If node references another template, swap it out with new_node = node.swap(newly_evald_node)
    def evaluate(node)
      update_attributes(node)
      if node.respond_to?(:each_child)
        node.each_child {|child| evaluate(child)}
      end
    end
    
    #Check each attribute for the appearance of 'prop:' and replace it with the evaluated property
    def update_attributes(node)
      if node.respond_to?(:attributes)
        node.attributes.each do |key, value|
          if value =~ /^prop:/
            val = evaluate_attribute(value.slice(5, value.length-5), node.parent.attributes)
            raise InvalidPropertyException.new("Property #{value} cannot be resolved") if val.nil?
            node.set_attribute(key, val) if val
          end
        end
      end
    end
    
    #Evaluate an attribute
    # First looks to see if there is a matching value in the parent's attributes
    # TODO: Then what?
    def evaluate_attribute(name, local_properties)
      if name.nil? || (name = name.strip).empty?
        nil
      elsif local_properties.has_key?(name)
        local_properties[name]
      else
        nil
      end
    end
    
  end
end