require File.join(File.dirname(__FILE__), "helper")

describe "Beholder::Parser" do
  
  describe "parse(template)" do
    
    before do
      @parser = Beholder::Parser.new(File.join(File.dirname(__FILE__), "templates"))
    end
    
    it "should raise a TemplateNotFoundException if the template doesn't exist" do
      lambda { @parser.parse('unknown/file/path') }.should raise_error(Beholder::TemplateNotFoundException)
    end
    
    it "should return the string representation of the html" do
      strip_html(@parser.parse('static')).should == "<html><head><title>Hello World</title></head><body><p>What's up, world?</p></body></html>"
    end
    
    it "should correctly resolve a template with and without the .beh extension" do
      strip_html(@parser.parse('static')).should == "<html><head><title>Hello World</title></head><body><p>What's up, world?</p></body></html>"
      strip_html(@parser.parse('static.beh')).should == "<html><head><title>Hello World</title></head><body><p>What's up, world?</p></body></html>"
    end
    
    it "should render a component in place of a component node" do
      strip_html(@parser.parse('attr_props.beh')).should == "<html><head><title>Hello World</title></head><body message_class=\"beholder\"><p class=\"beholder\">What's up, world?</p></body></html>"
    end
    
    it "should replace props with attribute values" do
      strip_html(@parser.parse('attr_props')).should == "<html><head><title>Hello World</title></head><body message_class=\"beholder\"><p class=\"beholder\">What's up, world?</p></body></html>"
    end
    
    it "should raise an InvalidPropertyException if a prop:name refers to a name that cannot be resolved" do
      lambda { @parser.parse('missing_prop') }.should raise_error(Beholder::InvalidPropertyException)
    end
    
    it "should replace props with local values"
    
    it "should replace props with the return value of helper methods"
    
  end
  
end