require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "voting" do
    r = ratings(:pos_only)
    assert_equal 0, r.negative
    assert_equal 1, r.rating
    rtg = r.vote(false)
    assert_equal 1, r.negative
    assert_equal rtg, r.rating
    assert r.rating < 1
  end
end
