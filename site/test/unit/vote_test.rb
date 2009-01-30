require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  # test "find by retort" do
  #    assert_equal 1, Vote.find_by_retort(retorts(:kennys_dad))
  #  end
  
  test "count all" do
    assert_equal 165, Vote.find(:all).size
  end
  
  test "find positive" do
    assert_equal 35, Vote.positive.size
  end
  
  test "find positive by retort" do
    assert_equal 1, retorts(:kennys_dad).votes.positive.size
    assert_equal 30, retorts(:authoritah).votes.positive.size
  end
  
  test "find negative by retort" do
    assert_equal 0, retorts(:kennys_dad).votes.negative.size
    assert_equal 50, retorts(:authoritah).votes.negative.size
    assert_equal 80, retorts(:afghan_goat).votes.negative.size
  end
end
