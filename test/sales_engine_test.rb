require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'

class SalesEngineTest < Minitest::Test
  def setup
    @empty_engine = SalesEngine.new
    @se = SalesEngine.from_csv({
      :items         => "./test/test_data/items_stub.csv",
      :merchants     => "./test/test_data/merchants_stub.csv",
      :invoices      => "./test/test_data/invoices_stub.csv",
      :invoice_items => "./test/test_data/invoice_items_stub.csv",
      :transactions  => "./test/test_data/transactions_stub.csv",
      :customers     => "./test/test_data/customers_stub.csv"
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

  def test_it_can_build_objects_from_csv_files
    items_location        = "./test/test_data/items_stub.csv"
    merchants_location    = "./test/test_data/merchants_stub.csv"
    invoices_location     = "./test/test_data/invoices_stub.csv"
    invoice_item_location = "./test/test_data/invoice_items_stub.csv"
    transactions_location = "./test/test_data/transactions_stub.csv"
    customers_location    = "./test/test_data/customers_stub.csv"
    args = {items: items_location, merchants: merchants_location, invoices: invoices_location, invoice_items: invoice_item_location, transactions: transactions_location, customers: customers_location}

    items_array, merchants_array =
    SalesEngine.read_all_csv(args)

    assert_equal 24, items_array.count
    assert_kind_of Item, items_array[0]
    assert_equal "Manchette cuir Mathilde", items_array[0].name

    assert_equal 32, merchants_array.count
    assert_kind_of Merchant, merchants_array[0]
    assert_equal "Shopin1901", merchants_array[0].name
  end

  def test_it_can_find_items_associated_with_a_merchant
    merchant = @se.merchants.find_by_id(10)
    actual = merchant.items
    expected = @se.items.find_all_by_merchant_id(10)

    assert_equal 2, actual.count
    assert_equal expected, actual
  end

  def test_it_can_find_merchant_associated_with_an_item
    item   = @se.items.find_by_id(1)
    actual = item.merchant

    assert_equal 10, actual.id
  end

  def test_it_can_find_a_merchants_invoices
    merchant = @se.merchants.find_by_id(10)
    invoice1 = @se.invoices.find_by_id(319)
    invoice2 = @se.invoices.find_by_id(320)

    assert_equal [invoice1, invoice2], merchant.invoices
  end

  def test_it_returns_an_empty_array_when_a_merchant_has_no_invoices
    merchant = @se.merchants.find_by_id(12334105)

    assert_equal [], merchant.invoices
  end

  def test_it_can_find_an_invoices_merchant
    invoice = @se.invoices.find_by_id(320)

    assert_equal @se.merchants.find_by_id(10), invoice.merchant
  end

  def test_it_can_find_an_invoices_items
    skip
    invoice = @se.invoices.find_by_id(20)
    invoice.items # => [item, item, item]
  end

  def test_it_can_find_an_invoices_transactions
    skip
    # invoice = @se.invoices.find_by_id(20)
    # invoice.transactions # => [transaction, transaction]
  end

  def test_it_can_find_an_invoices_customer
    skip
    # invoice = @se.invoices.find_by_id(20)
    # invoice.customer # => customer
  end

end
