class Attribution < ActiveRecord::Base
  belongs_to :retort
  
  def to_xml(options ={}, &block)
    xml=options[:builder] || Builder::XmlMarkup.new
    
    xml.attribution(:id=>self.id){
      xml.who(self.who)
      xml.when(self.when)
      xml.where(self.where)
      xml.how(self.how)
      }  
  end  
  
end
