require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test "stats" do
    population = [1, 3, 24, 17, 12, 6, 14]
    stats = ApplicationHelper::Statistics.new(population)
    assert_equal 7.597, ("%.3f" % stats.stddev).to_f
    assert_equal stats.stddev, stats.standard_deviation
    assert_equal 57.714, ("%.3f" % stats.variance).to_f
    assert_equal stats.variance, stats.var
    assert_equal 7, stats.size
    assert_equal 67.333, ("%.3f" % stats.sample_variance).to_f
    assert_equal stats.sample_variance, stats.sample_var
    assert_equal 8.206, ("%.3f" % stats.sample_standard_deviation).to_f
    assert_equal stats.sample_standard_deviation, stats.sample_stddev
  end
end