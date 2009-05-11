module Beholder
  
  #Exception raised when an invalid template path is passed to the parser
  class TemplateNotFoundException < Exception
    
    attr_accessor :message
    
    def initialize(path)
      self.message = "No template at #{path}"
    end
    
  end
  
  #Exception raised when a prop:name refers to a name that cannot be resolved
  class InvalidPropertyException < Exception
    
  end
  
  #Exception raised when a logic component expects an attribute that is not present
  class MissingAttributeException < Exception
    
  end
  
  #Exception raised when a logic component that is dependant on another component is executed on its own
  class DependantComponentException < Exception
    
  end
end