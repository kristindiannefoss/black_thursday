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
    expected = 0.75
    actual   = @sa.average_items_per_merchant

    assert_equal expected, actual
  end

  def test_it_can_find_standard_deviation_in_merchant_average
    expected = 0.8569568250501305
    actual   = @sa.average_items_per_merchant_standard_deviation

    assert_equal expected, actual
  end

  def test_it_can_display_merchants_with_high_item_count
    expected = [@se.merchants.find_by_id(10), @se.merchants.find_by_id(12334455)]
    actual   = @sa.merchants_with_high_item_count

    assert_equal expected, actual
  end

  def test_it_can_find_average_price_for_merchant_with_id
    expected = BigDecimal.new(75)
    actual   = @sa.average_item_price_for_merchant(10) # => BigDecimal

    assert_equal expected, actual
  end

  def test_it_can_find_the_average_price_for_all_merchants
    expected = BigDecimal.new("3.59375")
    actual   = @sa.average_average_price_per_merchant

    assert_equal expected, actual
  end

end
