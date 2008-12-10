require 'test_helper'

class RetortTest < ActiveSupport::TestCase
  #fixtures :retorts
  
  # Replace this with your real tests.
  test "complete save" do
  end
  
  test "xml" do
    r = Retort.new
    r.id = 123
    r.content = "Foo"
    assert "<retort id=\"123\"><content>Foo</content></retort>" = r.to_xml
    
    #<retort id="123">
    #  <content>Foo</content>
    #  <attribution id="987">
    #    <who>
    #    ...
    #  </attribution>
    #  <tags>
    #    <tag id="456">South_Partk</tag>
    #  </tags>
    #</retort>
  end
end
