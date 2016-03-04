require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require_relative '../lib/sales_analyst'

class SalesAnalystTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
      :items     => "./test/test_data/items_stub.csv",
      :merchants => "./test/test_data/merchants_stub.csv",
      :invoices  => "./test/test_data/invoices_stub.csv"
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
    expected = 0.86
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
    expected = BigDecimal.new("3.59")
    actual   = @sa.average_average_price_per_merchant

    assert_equal expected, actual
  end

  def test_it_can_find_golden_items
    expected = [@se.items.find_by_id(263397785)]
    actual   = @sa.golden_items # => [<item>, <item>, <item>, <item>]

    assert_equal expected, actual
  end

  def test_it_can_find_average_invoices_per_merchant
    expected =  0.97
    actual   =  @sa.average_invoices_per_merchant

    assert_equal expected, actual
  end

  def test_it_can_find_average_invoices_per_merchant_standard_deviation
    expected =  0.96
    actual   =  @sa.average_invoices_per_merchant_standard_deviation

    assert_equal expected, actual
  end

  def test_it_can_find_top_merchants_by_invoice_count
    expected =  []
    actual   =  @sa.top_merchants_by_invoice_count

    assert_equal expected, actual
  end

  def test_it_can_find_bottom_merchants_by_invoice_count
    expected =  []
    actual   =  @sa.bottom_merchants_by_invoice_count

    assert_equal expected, actual
  end

  def test_it_can_return_the_average_count_of_invoices_per_day
    assert_equal 4.43, @sa.average_invoices_per_day
  end

  def test_it_can_return_an_array_of_the_count_of_invoices_by_day
    expected = [["Sunday", 12], ["Tuesday", 3], ["Friday", 3], ["Thursday", 3], ["Monday", 6], ["Wednesday", 2], ["Saturday", 2]]

    assert_equal expected, @sa.invoice_count_by_day
  end

  def test_it_can_calculate_the_std_dev_of_invoices_per_day
    assert_equal 3.6, @sa.average_invoices_per_day_standard_deviation
  end

  def test_it_can_return_top_days_by_invoice_count
    expected =  ["Sunday"]
    actual   = @sa.top_days_by_invoice_count

    assert_equal expected, actual
  end

  def test_it_can_provide_percentages_by_status
    assert_equal 32.26, @sa.invoice_status(:pending) # => 5.25
    assert_equal 51.61, @sa.invoice_status(:shipped) # => 93.75
    assert_equal 16.13, @sa.invoice_status(:returned) # => 1.00
  end

end
