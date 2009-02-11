class Attribution < ActiveRecord::Base
  has_many :retorts
  
  # validates_each :when, :allow_nil => true, :if => Proc.new { |a| a.when and !a.when.blank? and !a.when.instance_of?(Date) and (a.when.instance_of?(String) and a.when.size > 0)} do |mdl, attr, val|
  validates_each :when, :allow_nil => true, :on => :create, :if => Proc.new { |a| 
    a.when and 
    !a.when.blank? and 
    !a.when.instance_of?(Date) and 
    (a.when.instance_of?(String) and a.when.size > 0)
  } do |mdl, attr, val|
    case val
      when /[0-9]{1,2}(([\/-](([0-9]{1,2})|([a-z]{3}))[\/-])|(\s[a-z]{4}\s))[0-9]{4}/ # date
        nil
      when /(january|feburary|march|april|may|june|july|august|september|october|november|december)\s([0-9]{1,2},\s)?[0-9]{4}/i #long form: january 1, 2009
        nil
      when /((ca\.|circa)\s)?[0-9]{4}/ #circa 2009
        nil
      else
        mdl.errors.add(attr, "Invalid date-like value")
    end
  end
  
  def to_xml(options ={}, &block)
    xml = options[:builder] || Builder::XmlMarkup.new
    
    xml.attribution(:id => self.id) do
      xml.who(self.who) unless self.who.nil?
      xml.what(self.what) unless self.what.nil?
      xml.when(self.when) unless self.when.nil?
      xml.where(self.where) unless self.where.nil?
      xml.how(self.how) unless self.how.nil?
    end
  end  
  
end
