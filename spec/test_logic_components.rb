require File.join(File.dirname(__FILE__), "helper")

describe "Beholder::LogicComponent" do
  
  before do
    @view = Beholder::View.new(File.join(File.dirname(__FILE__), "templates"))
  end
  
  describe "raw" do
    
    it "should raise a MissingAttributeException if the attribute 'value' isn't foud" do
      lambda { @view.parse('invalid_raw') }.should raise_error(Beholder::MissingAttributeException)
    end
    
    it "should replace the node with the value attribute" do
      strip_html(@view.parse('raw')).should == "#{DOCTYPE}<html><head><title>Hello World</title></head><body><p>Hello World!!!</p></body></html>"
    end
    
  end
#  
#  describe "yield" do
#    
#    it "should raise a DependantComponentException if it doesn't have a parent component node" do
#      lambda { @view.parse('invalid_yield') }.should raise_error(Beholder::DependantComponentException)
#    end
#    
#    it "should yield the contents of the node" do
#      strip_html(@view.parse('simple_yield_container')).should == "<html><head><title>Hello World</title></head><body><div>This text is inside the simple_yield_component</div></body></html>"
#    end
#    
#    it "should correctly yield nested components" do
#      strip_html(@view.parse('nested_yield_container')).should == "<html><head><title>Hello World</title></head><body><div><span>Message inside the nested_yield_component2: beholder2</span><span>Message inside the nested_yield_component1: beholder</span>Message inside the nested_yield_container: beholder</div></body></html>"
#    end
#    
#    it "should provide access to the parent component's attributes for the yielded node" do
#      strip_html(@view.parse('property_yield_container')).should == "<html><head><title>Hello World</title></head><body><div>Message inside the property_yield_component: beholder Message inside the property_yield_container: beholder</div></body></html>"
#    end
#    
#  end
#  
#  describe "if" do
#    
#    it "should raise a MissingAttributeException if the attribute 'condition' is not present" do
#      lambda { @view.parse('invalid_if') }.should raise_error(Beholder::MissingAttributeException)
#    end
#    
#    it "should replace the contents of the node if the value of 'condition' is true" do
#      strip_html(@view.parse('simple_if')).should == "<html><head><title>Hello World</title></head><body>Body of 'if' component</body></html>"
#    end
#    
#    it "should remove the node if the value of 'condition' is false" do
#      strip_html(@view.parse('simple_if_false')).should == "<html><head><title>Hello World</title></head><body></body></html>"
#    end
#    
#    it "should ignore component:elsif and component:else if the value of 'condition' is true" do
#      strip_html(@view.parse('complex_if')).should == "<html><head><title>Hello World</title></head><body>Body of 'if' component</body></html>"
#    end
#    
#  end
#  
#  describe "elsif" do
#  
#    it "should raise DependantComponentException if called on it's own" do
#      lambda { @view.parse('invalid_elsif') }.should raise_error(Beholder::DependantComponentException)
#    end
#    
#    it "should replace the contents of the node if the value of 'condition' is true" do
#      strip_html(@view.parse('complex_elsif')).should == "<html><head><title>Hello World</title></head><body>Body of 'elsif' component</body></html>"
#    end
#  end
#  
#  describe "else" do
#    
#    it "should raise DependantComponentException if called on it's own" do
#      lambda { @view.parse('invalid_else') }.should raise_error(Beholder::DependantComponentException)
#    end
#    
#    it "should replace the contents of the node if the value of 'condition' is false for component:if and all component:elsifs" do
#      strip_html(@view.parse('else')).should == "<html><head><title>Hello World</title></head><body>Body of 'else' component</body></html>"
#    end
#    
#  end
#  
#  describe "foreach" do
#    
#  end
#  
#  describe "count" do
#    
#    it "should raise MissingAttributeException if it is missing the 'count' attribute" do
#      lambda { @view.parse('invalid_count') }.should raise_error(Beholder::MissingAttributeException)
#    end
#    
#    it "should yield the block count times" do
#      strip_html(@view.parse('count')).should == "<html><head><title>Hello World</title></head><body><ol><li>Count: 0</li></ol><li>Count: 1</li></ol><li>Count: 2</li></ol><li>Count: 3</li></ol><li>Count: 4</li></ol></body></html>"
#    end
#  end
#  
end