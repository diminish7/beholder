module Beholder
  class View
    include Parser
    
    #Initialize the parser with the default template path
    def initialize(template_path)
      @template_path = template_path
      @removed = []
    end
    
  end
end