require 'test_helper'

class AttributionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "check for valid date in when field" do
    assert_equal true, Attribution.new(:when => Date.new()).valid?
    assert_equal true, Attribution.new(:when => '9/17/1974').valid?
    # assert_equal false, Attribution.new(:when => 'blahblah').valid?
    a = Attribution.new(:when => 'blahblah')
    assert_equal false, a.valid?
    assert_match /invalid/, a.errors.full_messages.join
    #assert_invalid_and_errors_match /invalid/, a.when  
  end
end
