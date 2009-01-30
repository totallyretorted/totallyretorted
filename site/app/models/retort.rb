class Retort < ActiveRecord::Base
  belongs_to :attribution
  has_and_belongs_to_many :tags
  has_many :votes
  
  belongs_to :user
  
  validates_presence_of :content
  validates_uniqueness_of :content
  validates_associated :attribution, :tags
  
  def positive
    self.votes.positive.size
  end
  
  def negative
    self.votes.negative.size
  end
  
  def rating
    denom = self.positive.to_f + self.negative.to_f
    denom == 0 ? 0 : self.positive.to_f / denom
  end
  
  def short_name(max_length = 20)
    if content.size > max_length
      sn = "#{content[0..(max_length - 4)]}..."
    else
      sn = content
    end
    sn
  end
  
  def self.quote_borat
    # quote = RetortsHelper::quote_borat
    # r = Retort.find_by_content(quote)
    # if r
    #   r
    # else
    #   r = Retort.new(:content => quote)
    #   r.tags << Tag.load("borat")
    #   r.save
    #   r
    # end
    r = Retort.find_or_create_by_content(:content => RetortsHelper::quote_borat)
    if r.tags and r.tags.size == 0
      r.tags << Tag.find_or_create_by_value(:value => "borat")
    end
    r.save
    r
  end
  
  def self.find_highly_regarded
    Retort.find(:all)
  end
  
  def self.screenzero_retorts
    randomRetorts = []
    num_retorts = 5
    
    retorts = Retort.find_highly_regarded
    if retorts.size < num_retorts
      first_index = retorts.size
      (first_index..num_retorts).each do |i|
        retorts << Retort.quote_borat
      end
    end

    num_retorts.times do
      index = rand(retorts.length)
      randomRetorts << retorts[index]
      retorts.slice!(index)
    end
    
    randomRetorts
  end

  def to_xml(options ={}, &block)
    xml = options[:builder] || Builder::XmlMarkup.new
      
    xml.retort(:id => self.id){
      xml.content(self.content)
      self.attribution.to_xml(:builder => xml) unless attribution.nil?
      # self.rating.to_xml(:builder => xml) unless rating.nil?
      xml.positive(self.positive)
      xml.negative(self.negative)
      xml.rating(self.rating)
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