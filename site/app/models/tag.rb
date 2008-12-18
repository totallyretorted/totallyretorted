class Tag < ActiveRecord::Base
  has_and_belongs_to_many :retorts
  
  # def weight
  #   @count=0
  #   retorts=Retort.find(:all)
  #   
  #   retorts.each do |retort|
  #     retort.tags.each do |tag|
  #       if tag.value==self.value
  #         @count+=1  
  #         break
  #       end
  #     end
  #   end
  #   @count
  # end
  
  def weight
    self.retorts.size
  end
  
  def tier
    all_tags = Tag.find(:all).sort!{|x,y| y.weight<=>x.weight}
    (all_tags.index(self))+1
  end
  
  # def tier(set_of_tags=[])
  #   set_of_tags ||= Tag.find(:all)
  #   Tag.quantify(self, set_of_tags)
  # end
  # 
  # def self.quantify(tag, set_of_tags)
  #   set_of_tags.sort!{ |x,y| x.weight <=> y.weight }
  # end
  
  def to_xml(options ={}, &block)
    xml = options[:builder] || Builder::XmlMarkup.new
    xml.tag(self.value, :id => self.id, :weight => self.weight)
  end
  
  def self.tagcloud_tags
    Tag.find(:all)
  end
end
