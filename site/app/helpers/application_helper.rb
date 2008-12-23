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
      self.standard_deviation = Math.sqrt(self.variance)
      self.sample_standard_deviation = Math.sqrt(self.sample_variance)
      self.size = n
      self.sample = s
    end
  end
end
