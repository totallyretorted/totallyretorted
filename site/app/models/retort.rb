class Retort < ActiveRecord::Base
  has_one :attribution
  has_and_belongs_to_many :tags
  has_one :rating
  
#  def to_xml(options = {})
#    options[:indent] ||= 2
#    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
#    xml.instruct! unless options[:skip_instruct]
#    xml.retort do
#      xml.tag!(:content)
#    end
#  end

#  def self.to_full_xml(r, options = {})
#   # if r[:tags] 
#    #  options[:include] = [:tags]
#    #end
#    options[:except] = [:retort_id, :tag_id, :created_at, :updated_at]
#    r.to_xml(options)
#  end
#  
#  def self.to_xml(r, options = {})
#    options[:except] = [:retort_id, :tag_id, :created_at, :updated_at]
#    r.to_xml(options)
#  end

  def to_xml(options ={}, &block)
    xml=options[:builder] || Builder::XmlMarkup.new
        
    
    xml.retort(:id => self.id) do
      xml.content(self.content)
      attribution.to_xml(:builder => xml) unless attribution.nil?
      rating.to_xml(:builder => xml) unless rating.nil?
      tags.each do |t|
        t.to_xml(:builder => xml)
      end unless tags.nil?
    end
  end
end
