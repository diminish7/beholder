require File.join(File.dirname(__FILE__), "helper")

describe "Beholder::Parser's logic components" do
  
  before do
    @parser = Beholder::Parser.new(File.join(File.dirname(__FILE__), "templates"))
  end
  
  describe "raw" do
    
    it "should raise a MissingAttributeException if the attribute 'value' isn't foud" do
      lambda { @parser.parse('invalid_raw') }.should raise_error(Beholder::MissingAttributeException)
    end
    
    it "should replace the node with the value attribute" do
      strip_html(@parser.parse('raw')).should == "<html><head><title>Hello World</title></head><body><p>Hello World!!!</p></body></html>"
    end
    
  end
  
  describe "yield" do
    
    it "should raise a DependantComponentException if it doesn't have a parent component node" do
      lambda { @parser.parse('invalid_yield') }.should raise_error(Beholder::DependantComponentException)
    end
    
    it "should yield the contents of the node" do
      strip_html(@parser.parse('simple_yield_container')).should == "<html><head><title>Hello World</title></head><body><div>This text is inside the simple_yield_component</div></body></html>"
    end
    
    it "should correctly yield nested components" do
      strip_html(@parser.parse('nested_yield_container')).should == "<html><head><title>Hello World</title></head><body><div><span>Message inside the nested_yield_component2: beholder2</span><span>Message inside the nested_yield_component1: beholder</span>Message inside the nested_yield_container: beholder</div></body></html>"
    end
    
    it "should provide access to the parent component's attributes for the yielded node" do
      strip_html(@parser.parse('property_yield_container')).should == "<html><head><title>Hello World</title></head><body><div>Message inside the property_yield_component: beholder Message inside the property_yield_container: beholder</div></body></html>"
    end
    
  end
  
  describe "if" do
    
    it "should raise a MissingAttributeException if the attribute 'condition' is not present"
    it "should replace the contents of the node if the value of 'condition' is true"
    it "should ignore component:elsif and component:else if the value of 'condition' is true"
    
  end
  
  describe "elsif" do
  
    it "should raise DependantComponentException if called on it's own" do
      lambda { @parser.parse('invalid_elsif') }.should raise_error(Beholder::DependantComponentException)
    end
    
    it "should replace the contents of the node if the value of 'condition' is true"
  end
  
  describe "else" do
    
    it "should raise DependantComponentException if called on it's own" do
      lambda { @parser.parse('invalid_else') }.should raise_error(Beholder::DependantComponentException)
    end
    
    it "should replace the contents of the node if the value of 'condition' is false for component:if"
    it "should replace the contents of the node if the value of 'condition' is false for component:if and all component:elsifs"
    
  end
  
  describe "foreach" do
    
  end
  
  describe "count" do
    
  end
  
end