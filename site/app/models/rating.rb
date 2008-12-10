class Rating < ActiveRecord::Base
  belongs_to :retort
  
  def to_xml(options ={}, &block)
    xml=options[:builder] || Builder::XmlMarkup.new
    
    xml.rating(){
      xml.positive(self.positive)
      xml.negative(self.negative)
      }  
  end  
  
end
