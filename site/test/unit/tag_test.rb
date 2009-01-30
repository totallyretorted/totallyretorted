require 'test_helper'

class TagTest < ActiveSupport::TestCase  
  test "xml" do
    t = Tag.find_or_create_by_value("south_park")
    t.retorts << Retort.find_or_create_by_content("Fuck you, Cartman")
    t.save
    
    doc = Hpricot::XML(t.to_xml)
    assert (doc/:tag).size >= 1
    assert_equal t.id, (doc/:tag)[0].attributes["id"].to_i
    
    doc = Hpricot::XML(t.to_xml({:deep => true}))
    assert (doc/:tag).size >= 1
    assert_equal t.id, (doc/:tag)[0].attributes["id"].to_i
    assert_equal 1, doc.search("/tag/retorts/retort/content[text()='Fuck you, Cartman']").size
  end
  
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
    assert_equal Tag.find_by_value("south_park").retorts.length, Tag.find_by_value("south_park").weight
    assert_equal Tag.find_by_value("cartman").retorts.length, Tag.find_by_value("cartman").weight
    assert_equal Tag.find_by_value("chef").retorts.length, Tag.find_by_value("chef").weight
  end
  
  # test "tag tiering" do
  #    assert_equal 1, Tag.find_by_value("south_park").tier
  #    assert_equal 2, Tag.find_by_value("cartman").tier
  #    assert_equal 3, Tag.find_by_value("chef").tier
  #  end
  
  test "advanced tag tiering" do
    tag_pop = [1, 3, 24, 17, 12, 6, 14]
    
    tag_pop.max.times do |i|
      r = Retort.new(:content => i.to_s)
      r.save!
    end

    tags = []
    tag_pop.each do |i|
      t = Tag.new(:value => i.to_s)
      i.times do |j|
        t.retorts << Retort.find_by_content(j.to_s)
      end
      t.save!
      tags << t
    end
    
    tags.each do |t|
      assert_equal t.value, t.weight.to_s
    end
    
    tiers = TagsHelper::quantify_tags(tags)
    assert_equal 0, tiers[:tier_1].size
    assert_equal 1, tiers[:tier_2].size
    assert_equal "24", tiers[:tier_2][0].value
    assert_equal 3, tiers[:tier_3].size
    assert_equal ["17", "14", "12"], tiers[:tier_3].sort!{|x,y| y.weight<=>x.weight}.collect{|t| t.value}
    assert_equal 1, tiers[:tier_4].size
    assert_equal "6", tiers[:tier_4][0].value
    assert_equal 2, tiers[:tier_5].size
    assert_equal ["3", "1"], tiers[:tier_5].sort!{|x,y| y.weight<=>x.weight}.collect{|t| t.value}
    assert_equal 0, tiers[:tier_6].size
  end
  
  test "create tagcloud" do
    tagcloud = Tag.create_tagcloud
    assert_not_nil tagcloud
    spk_hash = {:one => [1], :two => [2], :three => [3, 4]}
    assert_equal 3, spk_hash.size
    assert_equal 4, spk_hash.values.flatten!.size
    assert_equal Tag.tagcloud_tags.size, tagcloud.size
  end
  
  test "find by alpha" do
    assert_equal 2, Tag.find_by_alpha('C').size
    assert_equal 2, Tag.find_by_alpha('c').size
    assert_equal 0, Tag.find_by_alpha.size
    t = Tag.new(:value => 'ALPHA')
    t.save!
    assert_equal 1, Tag.find_by_alpha.size
  end
    
  test "find all alphas" do
    assert_equal ['C', 'S'], Tag.find_all_alphas
    t = Tag.new(:value => 'ALPHA')
    t.retorts << Retort.new(:content => 'something')
    t.save!
    assert_equal ['A', 'C', 'S'], Tag.find_all_alphas
  end
  
  test "find tags in use" do
    assert_equal 3, Tag.find_tags_in_use.size
  end
end
