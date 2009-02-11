require 'test_helper'

class AttributionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "date class for when attrib is valid" do
    assert_equal true, Attribution.new(:when => Date.new()).valid?
  end
  
  test "string date for when attrib is valid" do
    assert_equal true, Attribution.new(:when => '9/17/1974').valid?
  end
  
  test "date-like string for when attrib is valid" do
    assert_equal true, Attribution.new(:when => 'January 1, 2008').valid?
    assert_equal true, Attribution.new(:when => 'January 2008').valid?
    # assert_equal true, Attribution.new(:when => 'Jan. 2008').valid?
  end
  
  test "year string for when attrib is valid" do
  assert_equal true, Attribution.new(:when => '2008').valid?
  end
  
  test "circa string for when attrib is valid" do
    assert_equal true, Attribution.new(:when => 'circa 2008').valid?
    assert_equal true, Attribution.new(:when => 'ca. 2008').valid?
  end
  
  test "nonsense string for when attrib is not valid" do
    a = Attribution.new(:when => 'blahblah')
    assert_equal false, a.valid?
    assert_match /invalid/i, a.errors.full_messages.join
  end
end
