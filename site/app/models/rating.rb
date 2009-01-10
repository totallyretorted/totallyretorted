class Rating < ActiveRecord::Base
  has_one :retort
  
  def rating
     (positive.to_f / (positive.to_f + negative.to_f))
  end
  
  def to_xml(options ={}, &block)
    xml=options[:builder] || Builder::XmlMarkup.new
    
    xml.rating(){
      xml.positive(self.positive)
      xml.negative(self.negative)
      xml.rank(self.rating)
    }  
  end
  
  def vote(pos=false)
    if pos
      positive += 1
    else
      negative += 1
    end
    rating
  end
end
