class Retort < ActiveRecord::Base
  belongs_to :attribution
  has_and_belongs_to_many :tags
  belongs_to :rating
  
  def self.find_highly_regarded
    Retort.find(:all, :limit => 100)
  end
  
  def self.screenzero_retorts
    randomRetorts=[]
    
    retorts = Retort.find_highly_regarded

    5.times{
      index = rand(retorts.length)
      randomRetorts << retorts[index]
      retorts.slice!(index)
    }
    
    randomRetorts
  end

  def to_xml(options ={}, &block)
    xml = options[:builder] || Builder::XmlMarkup.new
      
    xml.retort(:id => self.id){
      xml.content(self.content)
      self.attribution.to_xml(:builder => xml) unless attribution.nil?
      self.rating.to_xml(:builder => xml) unless rating.nil?
      if tags && tags.count > 0 
        xml.tags{
          tags.each{ |tag| 
            tag.to_xml(:builder=>xml)
          }
        }
      end  
    }
  end
  
  def self.from_xml(xml)
    doc = Hpricot::XML(xml)
    r = Retort.new
    (doc/:retort).each do |r_tag|
      r.id = r_tag.attributes["id"]
      r.content = (r_tag/:content).inner_html
      (r_tag/:attribution).each do |attr_tag|
        a = Attribution.new
        a.id = attr_tag.attributes["id"]
        %w(who what where how when).each do |w|
          a.send("#{w}=", (attr_tag/w).inner_html)
        end
        r.attribution = a
      end
      # not consuming ratings...
      #(r_tag/:rating).each do |rtg_tag|
      #  rtg = Rating.new
      #  rtg = rtg_tag.attributes["id"]
      #  #rtg.positive = Integer((rtg_tag/:positive).inner_html)
      #  #rtg.negative = Integer((rtg_tag/:negative).inner_html)
      #  r.rating = rtg
      #end
      (r_tag/:tags/:tag).each do |t_tag|
        t = Tag.new
        t.id = t_tag.attributes["id"]
        t.value = t_tag.inner_html
        r.tags << t
      end
    end  
    r
  end
end