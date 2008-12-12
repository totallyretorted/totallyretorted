require 'test_helper'

class RetortTest < ActiveSupport::TestCase
  test "screenzero retorts" do
    retorts = Retort.screenzero_retorts
    assert_equal 5, retorts.size
  end
  
  test "check data" do
    r = Retort.find_by_content("Respect My Authority!")
    assert_equal 3, r.id
    assert_equal 2, r.tags.count
    assert_equal "south_park", r.tags[0].value
    assert_equal "cartman", r.tags[1].value
    assert_equal 30, r.rating.positive
    assert_equal 50, r.rating.negative
    assert_equal 0.375, r.rating.rating
    assert_equal "Eric Cartman", r.attribution.who
    assert_equal "South Park", r.attribution.where
  end
  
  test "deep save" do
    r = Retort.new
    r.content = "Screw you guys I'm going home"
    r.tags << Tag.new(:value => "south_park")
    r.tags << Tag.new(:value => "cartman")
    r.attribution = Attribution.new(:who => "Cartman", :where => "South Park")
    r.rating = Rating.new(:positive => 1, :negative => 0)
    r.save!
    
    ctrl = Retort.find_by_content("Screw you guys I'm going home")
    assert ctrl
    assert_equal 2, ctrl.tags.count
    assert ctrl.attribution
    assert_equal "Cartman", ctrl.attribution.who
    assert ctrl.rating
    assert_equal 1, ctrl.rating.positive
  end
  
  test "to_xml" do    
    r = Retort.new
    r.id = 123
    r.content = "Foo"
    r.created_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    r.updated_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    #r.attribution_id=1
    #r.rating_id=1
    
    r.to_xml
    
    assert_equal "<retort id=\"123\"><content>Foo</content></retort>", r.to_xml
  end
  
  test "to_xml (deep)" do
    r = Retort.new(:content => "Screw you guys I'm going home")
    r.id = 123
    t = Tag.new(:value => "south_park")
    t.id = 99
    r.tags << t
    t = Tag.new(:value => "cartman")
    t.id = 100
    r.tags << t
    a = Attribution.new(:id => 42, :who => "Cartman", :where => "South Park")
    a.id = 42
    r.attribution = a
    rt = Rating.new(:id => 88, :positive => 1, :negative => 0)
    rt.id = 88
    r.rating = rt 
    
    xml = Builder::XmlMarkup.new
    xml.retort(:id => 123) do
      xml.content("Screw you guys I'm going home")
      xml.tags do
        xml.tag("south_park", :id => 99, :weight =>100)
        xml.tag("cartman", :id => 100, :weight=>200)
      end
      xml.attribution(:id => 42) do
        xml.who("Cartman")
        xml.where("South Park")
      end
      xml.rating(:id => 88) do
        xml.positive(1)
        xml.negative(0)
        xml.rating(1)
      end
    end
    assert_equal xml, r.to_xml
  end
  
  test "from_xml" do
    xml = Builder::XmlMarkup.new
    xml.retort(:id => 123) do
      xml.content("Screw you guys I'm going home")
      xml.tags do
        xml.tag("south_park", :id => 99, :weight =>100)
        xml.tag("cartman", :id => 100, :weight=>200)
      end
      xml.attribution(:id => 42) do
        xml.who("Cartman")
        xml.where("South Park")
      end
      xml.rating(:id => 88) do
        xml.positive(1)
        xml.negative(0)
        xml.rating(1)
      end
    end
    
    r = Retort.from_xml(xml)
    assert_equal 123, r.id
    assert_equal "Screw you guys I'm going home", r.content
    assert_equal 2, r.tags.size
    assert_equal "south_park", r.tags[0].value
    assert_equal "Cartman", r.attribution.who
  end
end
