class Tag < ActiveRecord::Base
  has_and_belongs_to_many :retorts
  attr_accessor :cloud_tier
  alias :tier :cloud_tier
  
  def name
    self.value.camelize
  end
  
  def weight
    self.retorts.size
  end
  
  def to_xml(options ={}, &block)
    xml = options[:builder] || Builder::XmlMarkup.new
    xml.tag(:id => self.id, :weight => self.weight){
      xml.value(self.value)
      if options[:deep]
        xml.retorts{
          self.retorts.each{ |retort| 
            retort.to_xml(:builder => xml)
          }
        }
      end
    }
  end
  
  def self.tagcloud_tags
    Tag.find(:all, :limit => 50)
  end
  
  def self.create_tagcloud(tag_population=Tag.tagcloud_tags)
    tags = []
    tiers = TagsHelper::quantify_tags(tag_population)
    tiers.each do |tier, tagarray|
      tagarray.each do |tag|
        tag.cloud_tier = tier.to_s[5,1].to_i
        tags << tag
      end
    end
    tags
  end
end
