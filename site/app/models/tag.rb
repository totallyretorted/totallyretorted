class Tag < ActiveRecord::Base
  has_and_belongs_to_many :retorts
  
  def weight
    self.retorts.tags.count(:conditions =>"value=self.value")
  end
  
  def to_xml(options ={}, &block)
    xml=options[:builder] || Builder::XmlMarkup.new
    xml.tag(self.value,:id=>self.id)
    xml.weight(self.weight)
  end  
  
end
