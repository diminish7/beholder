module Beholder
  module Parser
    include LogicComponent
    include NodeUtils
    
    #Parses a template and returns the full HTML string
    def parse(template)
      @component_stack = []
      path = resolve_template_path(template)
      raise TemplateNotFoundException.new(template) unless File.exist?(path)
      html = open(path) { |f| Nokogiri::HTML.parse(f) }
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
    def evaluate(node, local_attrs = {})
      #Evaluate dynamic properties in a node
      update_attributes(node, local_attrs)
      #Evaluate node as a component, if applicable, otherwise recurse down the tree
      resolve_as_component(node) || resolve_children(node)
    end
    
    #Check each attribute for the appearance of 'prop:' and replace it with the evaluated property
    def update_attributes(node, local_attrs = {})
      if node.attributes
        node.attributes.each do |key, value|
          s_val = value.to_s
          if s_val =~ /^prop:/
            val = evaluate_attribute(s_val.slice(5, s_val.length-5), local_attrs)
            raise InvalidPropertyException.new("Property #{value} cannot be resolved") if val.nil?
            node.set_attribute(key, val) if val
          end
        end
      end
    end
    
    #Evaluate an attribute
    # First looks to see if there is a matching value in the local attributes
    # TODO: Then what?
    def evaluate_attribute(name, local_attrs = {})
      if name.nil? || (name = name.strip).empty?
        nil
      elsif local_attrs.has_key?(name)
        local_attrs[name]
      elsif (parent = @component_stack.last) && (attr = parent.attributes[name])
        attr
      else
        nil
      end
    end
    
    #Check to see if there is a 'component' attribute and swap the node for the component if applicable
    def resolve_as_component(node)
      if node.attributes && (component = node.attributes['component'])
        @component_stack.push(node) unless node.attributes['component'] == 'yield'
        #Try to resolve as a logic component
        if self.respond_to?(mname = "_#{component}")
          node_set = self.send(mname, node)
        else
          #Then try to resolve as a partial
          path = resolve_template_path(component.to_s)
          raise TemplateNotFoundException.new(template) unless File.exist?(path)
          node_set = swap(node, Nokogiri::HTML.fragment((open(path) { |f| f.read })).children)
        end
        node_set.each { |n| evaluate(n, node.attributes) }
        @component_stack.delete(node)
        true
      else
        false
      end
    end
    
    #Check to see if this can have children and iterate through the children
    def resolve_children(node)
      node.children.each {|child| evaluate(child)} if node.children
    end
    
  end
end