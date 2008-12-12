require 'test_helper'

class TagTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  
  test "weight" do
    
    retorts=[]
    
    {1=>"shant", 2=>"alex", 3=>"jay"}.each do |k,v|
      t=Tag.new
      t.id=k
      t.value=v
      t.created_at=Time.now.strftime("%Y-%m-%d %H:%M:%S")
      t.updated_at=Time.now.strftime("%Y-%m-%d %H:%M:%S")
      
      {123 => "foo", 1234 => "foo2"}.each do |k,v|  
        r=Retort.new
        r.id=k
        r.content=v
        r.created_at=Time.now.strftime("%Y-%m-%d %H:%M:%S")
        r.updated_at=Time.now.strftime("%Y-%m-%d %H:%M:%S")
        r.tags<<t
        retorts<<r
      end
    end    
    
    shantWeight=0
    alexWeight=0
    jayWeight=0
    
    retorts.each do |retort|
      retort.tags.each do |tag|    
        case tag.value
          when "shant":
            shantWeight+=1
          when "alex":
            alexWeight+=1
          when "jay":
            jayWeight+=1
        end
        
      end
    end
        
    if shantWeight==2 && alexWeight==2 && jayWeight==2
      assert true
    else
      assert false
    end        
 end
  
  test "tag weight" do
    #assert_equal 6, Tag.find_by_value("south_park").length
    #assert_equal 5, Tag.find_by_value("cartman").length
    #assert_equal 1, Tag.find_by_value("chef").length
    assert true
  end
  
  test "the truth" do
    assert true
  end
end
