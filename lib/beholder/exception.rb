module Beholder
  
  #Exception thrown when an invalid template path is passed to the parser
  class TemplateNotFoundException < Exception
    
    attr_accessor :message
    
    def initialize(path)
      self.message = "No template at #{path}"
    end
    
  end
  
  #Exception thrown when a prop:name refers to a name that cannot be resolved
  class InvalidPropertyException < Exception
    
  end
  
end