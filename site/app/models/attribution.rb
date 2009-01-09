class Attribution < ActiveRecord::Base
  has_many :retorts
  
  validates_each :when, :allow_nil => true do |mdl, attr, val|
    if not val.instance_of?(Date)
      case val
        when /[0-9]{1,2}(([\/-](([0-9]{1,2})|([a-z]{3}))[\/-])|(\s[a-z]{4}\s))[0-9]{4}/ # date
          0
        when /(january|feburary|march|april|may|june|july|august|september|october|november|december)\s([0-9]{1,2},\s)?[0-9]{4}/i #long form: january 1, 2009
          0
        when /(ca\.|circa)\s[0-9]{4}/ #circa 2009
          0
        else
          mdl.errors.add(attr, "Invalid date-like value")
      end
    end
  end
  
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
