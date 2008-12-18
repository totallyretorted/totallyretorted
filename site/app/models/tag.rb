class Tag < ActiveRecord::Base
  has_and_belongs_to_many :retorts
  
  # def weight
  #   
  #   #todo there should be a better way, probably slow
  #   @count=0
  #   retorts=Retort.find(:all)
  #   
  #   retorts.each do |retort|
  #     retort.tags.each do |tag|
  #       if tag.value==self.value
  #         @count+=1  
  #         break
  #       end
  #     end
  #   end
  #   @count
  # end
  
  def weight
    self.retorts.size
  end
  
  def to_xml(options ={}, &block)
    xml = options[:builder] || Builder::XmlMarkup.new
    xml.tag(self.value, :id => self.id, :weight => self.weight)
  end  
  
end
