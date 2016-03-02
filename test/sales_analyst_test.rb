require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require_relative '../lib/sales_analyst'

class SalesAnalystTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
      :items     => "./test/test_data/items_stub.csv",
      :merchants => "./test/test_data/merchants_stub.csv"
    })
    @sa = SalesAnalyst.new(@se)
  end

  def test_it_can_be_created_with_new
    assert_kind_of SalesAnalyst, @sa
  end

  def test_it_can_calculate_the_average_items_per_merchant
    expected = 2.25
    actual   = @sa.average_items_per_merchant

    assert_equal expected, actual
  end

  def test_it_can_test_for_standard_deviation_in_merchant_average
    expected = 2.7613402542968153
    actual   = @sa.average_items_per_merchant_standard_deviation

    assert_equal expected, actual
  end

end
