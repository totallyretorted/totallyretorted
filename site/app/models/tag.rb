class Tag < ActiveRecord::Base
  has_and_belongs_to_many :retorts
  
  def weight
    #self.retorts.tags.count(:conditions => "value=self.value")
    # TODO: implement
    0
  end
  
  def to_xml(options ={}, &block)
    xml = options[:builder] || Builder::XmlMarkup.new
    xml.tag(self.value, :id => self.id, :weight => self.weight)
  end  
  
end
