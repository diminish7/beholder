module Beholder
  class Parser
    
    #Initialize the parser with the default template path
    def initialize(template_path)
      @template_path = template_path
    end
    
    #Parses a template and returns the full HTML string
    def parse(template)
      path = resolve_template_path(template)
      raise TemplateNotFoundException.new(template) unless File.exist?(path)
      html = open(path) { |f| Hpricot(f) }
      evaluate(html)
      html.to_s
    end
    
  private
    #Resolve the template path from the template name
    def resolve_template_path(template)
      template += '.beh' unless template =~ /(\.beh)$/
      File.join(@template_path, template)
    end
    
    #Evaluate a node recursively
    # TODO: If node references another template, swap it out with new_node = node.swap(newly_evald_node)
    def evaluate(node, local_attrs = {})
      #Evaluate dynamic properties in a node
      update_attributes(node, local_attrs)
      #Evaluate node as a component, if applicable, otherwise recurse down the tree
      resolve_as_component(node) || resolve_children(node)
    end
    
    #Check each attribute for the appearance of 'prop:' and replace it with the evaluated property
    def update_attributes(node, local_attrs = {})
      if node.respond_to?(:attributes)
        node.attributes.each do |key, value|
          if value =~ /^prop:/
            val = evaluate_attribute(value.slice(5, value.length-5), local_attrs)
            raise InvalidPropertyException.new("Property #{value} cannot be resolved") if val.nil?
            node.set_attribute(key, val) if val
          end
        end
      end
    end
    
    #Check to see if there is a 'component' attribute and swap the node for the component if applicable
    def resolve_as_component(node)
      #TODO: If this node contain content, need to allow a component to yield it
      # Maybe pass in a yield stack?  Need to be able to yield at multiple depths...
      if node.respond_to?(:attributes) && (component = node.attributes['component'])
        path = resolve_template_path(component)
        raise TemplateNotFoundException.new(template) unless File.exist?(path)
        new_node = node.swap(open(path) { |f| f.read })
        new_node = [ new_node ] unless new_node.respond_to?(:each)
        new_node.each { |n| evaluate(n, node.attributes) }
        true
      else
        false
      end
    end
    
    #Check to see if this can have children and iterate through the children
    def resolve_children(node)
      node.each_child {|child| evaluate(child)} if node.respond_to?(:each_child)
    end
    
    #Evaluate an attribute
    # First looks to see if there is a matching value in the local attributes
    # TODO: Then what?
    def evaluate_attribute(name, local_attrs = {})
      if name.nil? || (name = name.strip).empty?
        nil
      elsif local_attrs.has_key?(name)
        local_attrs[name]
      else
        nil
      end
    end
    
  end
end