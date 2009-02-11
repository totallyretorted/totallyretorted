class Tag < ActiveRecord::Base  
  has_and_belongs_to_many :retorts
  attr_accessor :cloud_tier
  alias :tier :cloud_tier
  
  validates_presence_of :value
  validates_uniqueness_of :value
  
  in_use = {
    :joins => ["INNER JOIN (SELECT tag_id, COUNT(retort_id) AS weight FROM retorts_tags GROUP BY tag_id) ON tag_id = id"], 
    :conditions => ["weight > 0"]
  }
  
  named_scope :weighted, lambda {
    in_use
  }
  
  named_scope :find_tags_in_use, lambda {
    in_use.merge(:order => 'value ASC')
  }
  
  named_scope :bestest, lambda {
    in_use.merge(:order => "weight DESC", :limit => 500)
  }
  
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
  
  def self.find_by_alpha(options={})
    options[:alpha] ||= 'A'
    Tag.find(:all, :conditions => ['value LIKE ?', "#{options[:alpha]}%"], :order => 'value ASC')
  end
    
  def self.find_all_alphas
    # this should prolly become a raw SQL query, similar to this:
    #   self.connection.select_values("SELECT DISTINCT SUBSTRING(value, 0, 1) FROM tags")
    # however, SQLite uses SUBSTR (like Oracle), where MySQL (and others) use SUBSTRING
    # possibly could inject a substr method into ActiveRecord::ConnectionAdapters::AbstractAdapter and override it in ActiveRecord::ConnectionAdapters::SQLiteAdapter
    # but for the moment we'll use this, which will kill us with any volume (*gulp*)
    Tag.find_tags_in_use.collect{ |t| t.value[0..0].upcase }.uniq
  end
end
