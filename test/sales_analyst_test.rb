require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require_relative '../lib/sales_analyst'

class SalesAnalystTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
      :items     => "./test/test_data/items_stub.csv",
      :merchants => "./test/test_data/merchants_stub.csv",
      :invoices  => "./test/test_data/invoices_stub.csv",
      :invoice_items => "./test/test_data/invoice_items_stub.csv",
      :transactions => "./test/test_data/transactions_stub.csv",
      :customers    => "./test/test_data/customers_stub.csv"
    })
    @sa = SalesAnalyst.new(@se)

    @se_synthetic_data = SalesEngine.from_csv({
    :items         => "./test/test_data/fudge_data/items_stub.csv",
    :merchants     => "./test/test_data/fudge_data/merchants_stub.csv",
    :invoices      => "./test/test_data/fudge_data/invoices_stub.csv",
    :invoice_items => "./test/test_data/fudge_data/invoice_items_stub.csv",
    :transactions  => "./test/test_data/fudge_data/transactions_stub.csv",
    :customers     => "./test/test_data/fudge_data/customers_stub.csv"
    })

    @sa_synthetic_data = SalesAnalyst.new(@se_synthetic_data)

    @se_actual = SalesEngine.from_csv({
    :items         => "./data/items.csv",
    :merchants     => "./data/merchants.csv",
    :invoices      => "./data/invoices.csv",
    :invoice_items => "./data/invoice_items.csv",
    :transactions  => "./data/transactions.csv",
    :customers     => "./data/customers.csv"
    })

    @sa_actual = SalesAnalyst.new(@se_actual)

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

  def test_it_can_calculate_total_revenue_by_day_for_a_given_day
    assert_equal 2728.45, @sa_synthetic_data.total_revenue_by_date(Time.parse('2016-02-28 20:57:42 UTC'))
  end

  def test_it_can_return_top_revenue_earners
    assert_kind_of Merchant, @sa_synthetic_data.top_revenue_earners(3)[0]
    assert_equal 2, @sa_synthetic_data.top_revenue_earners(3)[0].id
  end

  def test_it_can_find_merchants_with_a_pending
    assert_kind_of Merchant, @sa_actual.merchants_with_pending_invoices[0]
    assert_equal 12335955, @sa_actual.merchants_with_pending_invoices[0].id
    assert_equal 467, @sa_actual.merchants_with_pending_invoices.count
  end

  def test_it_can_find_merchants_with_only_one_item
    assert_kind_of Merchant, @sa_actual.merchants_with_only_one_item[0]
  end

  def test_it_can_find_merchants_with_only_one_item_by_month
    actual = @sa_actual.merchants_with_only_one_item_registered_in_month("March")
    assert_kind_of Merchant, actual[0]
    assert_equal 21, actual.length
    assert_equal 12334113, actual[0].id
  end

  def test_it_can_find_a_merchants_revenue
    assert_equal 875, @sa_synthetic_data.revenue_by_merchant(1)
  end

  def test_it_can_return_the_best_selling_items_for_a_merchant
    actual = @sa_actual.most_sold_item_for_merchant(12334145)


    assert_kind_of Item, actual[0]
    assert_equal 3, actual.count
  end

  def test_it_can_return_the_best_item_for_a_merchant_in_terms_of_revenue
    actual = @sa_actual.best_item_for_merchant(12334145)

    assert_kind_of Item, actual
    assert_equal 263412097, actual.id
    #=> item (in terms of revenue generated)
  end

end
