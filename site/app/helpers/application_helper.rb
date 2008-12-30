# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper 
  class Statistics
    attr_accessor :mean, :variance, :standard_deviation, :size, :sample, :sample_variance, :sample_standard_deviation
    alias :stddev :standard_deviation
    alias :sample_stddev :sample_standard_deviation
    alias :var :variance
    alias :sample_var :sample_variance
    
    def initialize(population=[])
      n = 0
      mean = 0.0
      s = 0.0
      population.each { |x|
        n = n + 1
        delta = x - mean
        mean = mean + (delta / n)
        s = s + delta * (x - mean)
      }
      self.mean = mean
      self.variance = (s / n)
      self.sample_variance = (s / (n - 1))
      
      if (self.variance and self.variance > 0)
        self.standard_deviation = Math.sqrt(self.variance)
      else
        self.standard_deviation = 0.0
      end

      if (self.sample_variance and self.sample_variance > 0) 
        self.sample_standard_deviation = Math.sqrt(self.sample_variance) 
      else
        self.sample_standard_deviation = 0.0 
      end
      
      self.size = n
      self.sample = s
    end
  end
  
  def curvy_corners(name="element_#{Time.new.object_id}", options={}, &block)
    block_to_partial('common/curvy_box', options.merge(:name => name), &block) 
  end
  
  def alphabet
    ["#"]+(65..90).collect{ |i| i.chr }
  end
  
  def render_toolbar(&block)
    #block_to_partial('common/toolbar', {}, &block)
    render :partial => 'common/toolbar'
  end
  
  def render_tagcloud(tags)
    #block_to_partial('common/tag_cloud', {:tagcloud => tags}, &block)
    render :partial => 'common/tag_cloud', :locals => {:tagcloud => tags}
  end
  
  # Only need this helper once, it will provide an interface to convert a block into a partial.
    # 1. Capture is a Rails helper which will 'capture' the output of a block into a variable
    # 2. Merge the 'body' variable into our options hash
    # 3. Render the partial with the given options hash. Just like calling the partial directly.
  def block_to_partial(partial_name, options = {}, &block)
    options.merge!(:body => capture(&block))
    concat(render(:partial => partial_name, :locals => options), block.binding)
  end

  # Create as many of these as you like, each should call a different partial 
    # 1. Render 'shared/rounded_box' partial with the given options and block content
  def rounded_box(title, options = {}, &block)
    block_to_partial('common/rounded_box', options.merge(:title => title), &block)
  end

  # def un_rounded_box(title, options = {}, &block)
  #   block_to_partial('common/un_rounded_box', options.merge(:title => title), &block)
  # end
end
