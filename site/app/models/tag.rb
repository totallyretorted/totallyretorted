class Tag < ActiveRecord::Base
  has_and_belongs_to_many :retorts
  
  def to_xml(options ={}, &block)
    xml=options[:builder] || Builder::XmlMarkup.new
    xml.tag(self.value,:id=>self.id)
  end  
  
end
