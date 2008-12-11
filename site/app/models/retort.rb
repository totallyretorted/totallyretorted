require 'xml'

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
      
    xml.retort(:id => self.id){
      xml.content(self.content)
      if self.attribution
        self.attribution.to_xml(:builder => xml)
      end
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
#    xml = File.read('timeline.xml')
#    puts Benchmark.measure {
#      parser, parser.string = XML::Parser.new, xml
#      doc, statuses = parser.parse, []
#      doc.find('//statuses/status').each do |s|
#        h = {:user => {}}
#        %w[created_at id text source truncated in_reply_to_status_id in_reply_to_user_id favorited].each do |a|
#          h[a.intern] = s.find(a).first.content
#        end
#        %w[id name screen_name location description profile_image_url url protected followers_count].each do |a|
#          h[:user][a.intern] = s.find('user').first.find(a).first.content
#        end
#        statuses << h
#      end
#      # pp statuses
#    }

    parser, parser.string = XML::Parser.new, xml
    doc, retorts = parser.parse, []
    doc.find('//retort').each do |r|
      h = {:retort => {}}
      %w[id].each do |a|
        h[:retort][a.intern] = s.find(a).first.content
      end
      retorts << h
    end
    retorts
  end
end
