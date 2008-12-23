module TagsHelper
  def self.quantify_tags(population)
    if population.length == 0
      return {}
    end
    weights = population.collect{|t| t.weight }
    stats = ApplicationHelper::Statistics.new(weights)
    quanta = {:tier_1 => [], :tier_2 => [], :tier_3 => [], :tier_4 => [], :tier_5 => [], :tier_6 => []}
    population.each do |t|
      if t.weight >= ((2 * stats.stddev) + stats.mean)
        quanta[:tier_1] << t
      elsif t.weight >= (stats.stddev + stats.mean)
        quanta[:tier_2] << t
      elsif t.weight >= stats.mean
        quanta[:tier_3] << t
      elsif t.weight >= (stats.mean - stats.stddev)
        quanta[:tier_4] << t
      elsif t.weight >= (stats.mean - (2 * stats.stddev))
        quanta[:tier_5] << t
      else
        quanta[:tier_6] << t
      end
    end
    quanta
  end
end
