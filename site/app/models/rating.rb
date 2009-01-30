class Rating < ActiveRecord::Base
  # has_one :retort
  #  
  #  def rating
  #     (self.positive.to_f / (self.positive.to_f + self.negative.to_f))
  #  end
  #  
  #  def to_xml(options ={}, &block)
  #    xml=options[:builder] || Builder::XmlMarkup.new
  #    
  #    xml.rating(){
  #      xml.positive(self.positive)
  #      xml.negative(self.negative)
  #      xml.rank(self.rating)
  #    }  
  #  end
  #  
  #  def vote(pos=false)
  #    if pos
  #      self.positive += 1
  #    else
  #      self.negative += 1
  #    end
  #    self.rating
  #  end
end
