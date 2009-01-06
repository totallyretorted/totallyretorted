require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test "basic stats" do
    population = [1, 3, 24, 17, 12, 6, 14]
    stats = ApplicationHelper::Statistics.new(population)
    assert_equal 7.597, ("%.3f" % stats.stddev).to_f
    assert_equal stats.stddev, stats.standard_deviation
    assert_equal 57.714, ("%.3f" % stats.variance).to_f
    assert_equal stats.variance, stats.var
    assert_equal population.size, stats.size
    assert_equal 67.333, ("%.3f" % stats.sample_variance).to_f
    assert_equal stats.sample_variance, stats.sample_var
    assert_equal 8.206, ("%.3f" % stats.sample_standard_deviation).to_f
    assert_equal stats.sample_standard_deviation, stats.sample_stddev
  end
  
  test "zero stats" do
    population = [0]
    stats = ApplicationHelper::Statistics.new(population)
    assert_equal 0.0, ("%.3f" % stats.stddev).to_f
    assert_equal stats.stddev, stats.standard_deviation
    assert_equal 0.0, ("%.3f" % stats.variance).to_f
    assert_equal stats.variance, stats.var
    assert_equal population.size, stats.size
    assert_equal 0.0, ("%.3f" % stats.sample_variance).to_f
    assert stats.sample_var.nan?
    assert_equal 0.0, ("%.3f" % stats.sample_standard_deviation).to_f
    assert_equal stats.sample_standard_deviation, stats.sample_stddev
  end
  
  test "lotsa zero stats" do
    population = [0,0,0,0,0,0,0,0,0]
    stats = ApplicationHelper::Statistics.new(population)
    assert_equal 0.0, ("%.3f" % stats.stddev).to_f
    assert_equal stats.stddev, stats.standard_deviation
    assert_equal 0.0, ("%.3f" % stats.variance).to_f
    assert_equal stats.variance, stats.var
    assert_equal population.size, stats.size
    assert_equal 0.0, ("%.3f" % stats.sample_variance).to_f
    assert_equal stats.sample_variance, stats.sample_var
    assert_equal 0.0, ("%.3f" % stats.sample_standard_deviation).to_f
    assert_equal stats.sample_standard_deviation, stats.sample_stddev
  end

  test "null stats" do
    population = []
    stats = ApplicationHelper::Statistics.new(population)
    assert_equal 0.0, ("%.3f" % stats.stddev).to_f
    assert_equal stats.stddev, stats.standard_deviation
    assert_equal 0.0, ("%.3f" % stats.variance).to_f
    assert stats.var.nan?
    assert_equal population.size, stats.size
    assert_equal 0.0, ("%.3f" % stats.sample_variance).to_f
    assert_equal stats.sample_variance, stats.sample_var
    assert_equal 0.0, ("%.3f" % stats.sample_standard_deviation).to_f
    assert_equal stats.sample_standard_deviation, stats.sample_stddev
  end
end