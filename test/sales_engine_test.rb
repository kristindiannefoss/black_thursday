require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'

class SalesEngineTest < Minitest::Test
  def setup
    @empty_engine = SalesEngine.new
    @se = SalesEngine.from_csv({
      :items     => "./test/test_data/items_stub.csv",
      :merchants => "./test/test_data/merchants_stub.csv"
    })
  end

  def test_it_can_be_created_with_new
    assert_kind_of SalesEngine, @empty_engine
  end

  def test_it_can_be_created_using_from_csv
    assert_kind_of SalesEngine, @se
  end

  def test_it_can_access_a_populated_item_repository
    ir   = @se.items
    item = ir.find_by_name("Manchette cuir Mathilde")

    assert_kind_of Item, item
    assert_equal "Manchette cuir Mathilde", item.name
  end

  def test_it_can_access_a_populated_merchant_repository
    mr = @se.merchants
    merchant = mr.find_by_name("Shopin1901")

    assert_kind_of Merchant, merchant
    assert_equal "Shopin1901", merchant.name
  end

  def test_it_can_read_items_from_a_csv
    items_array = SalesEngine.read_items("./test/test_data/items_stub.csv")

    assert_equal 6, items_array.count
    assert_kind_of Item, items_array[0]
    assert_equal "Manchette cuir Mathilde", items_array[0].name
  end

  def test_it_can_read_merchants_from_a_csv
    merchants_array = SalesEngine.read_merchants("./test/test_data/merchants_stub.csv")

    assert_equal 3, merchants_array.count
    assert_kind_of Merchant, merchants_array[0]
    assert_equal "Shopin1901", merchants_array[0].name
  end

end
