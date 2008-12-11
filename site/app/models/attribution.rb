class Attribution < ActiveRecord::Base
  belongs_to :retort
  
  def to_xml(options ={}, &block)
    xml = options[:builder] || Builder::XmlMarkup.new
    
    xml.attribution(:id => self.id){
      xml.who(self.who) unless self.who.nil?
      xml.what(self.what) unless self.what.nil?
      xml.when(self.when) unless self.when.nil?
      xml.where(self.where) unless self.where.nil?
      xml.how(self.how) unless self.how.nil?
    }  
  end  
  
end
