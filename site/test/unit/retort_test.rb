require 'test_helper'

class RetortTest < ActiveSupport::TestCase
  # Replace this with your real tests.
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
    assert ctrl.tags.count == 2
    assert ctrl.attribution
    assert ctrl.attribution.who == "Cartman"
    assert ctrl.rating
    assert ctrl.rating.positive == 1
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
    
    assert "<retort id=\"123\"><content>Foo</content></retort>" == r.to_xml, r.to_xml
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
    assert xml == r.to_xml, "Expected '#{xml}', found '#{r.to_xml}'"
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
    
    #puts Retort.from_xml(xml)
    r = Retort.from_xml(xml)
    puts r
    assert r.id == 123
    assert r.content == "Screw you guys I'm going home"
    assert r.tags.count == 2
    assert r.tags[0].value == "south_park"
    assert r.attribution.who == "Cartman"
    assert r.rating.positive == 1    
  end
end
