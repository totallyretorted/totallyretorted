require 'test_helper'

class RetortTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "xml" do
    
    r=Retort.new
    r.id=333
    r.content="Foo"
    r.created_at=Time.now.strftime("%Y-%m-%d %H:%M:%S")
    r.updated_at=Time.now.strftime("%Y-%m-%d %H:%M:%S")
    r.attribution_id=1
    r.rating_id=1
    
    r.to_xml
    
    assert true
  end
end
