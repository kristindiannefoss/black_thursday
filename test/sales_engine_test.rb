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

    @se_synthetic_data = SalesEngine.from_csv({
    :items         => "./test/test_data/fudge_data/items_stub.csv",
    :merchants     => "./test/test_data/fudge_data/merchants_stub.csv",
    :invoices      => "./test/test_data/fudge_data/invoices_stub.csv",
    :invoice_items => "./test/test_data/fudge_data/invoice_items_stub.csv",
    :transactions  => "./test/test_data/fudge_data/transactions_stub.csv",
    :customers     => "./test/test_data/fudge_data/customers_stub.csv"
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

  def test_it_can_find_items_associated_with_a_merchant
    merchant = @se.merchants.find_by_id(10)
    actual   = merchant.items
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
    invoice = @se_synthetic_data.invoices.find_by_id(1)
    assert_kind_of Item, invoice.items[0] # => [item, item, item]
    assert_equal 1, invoice.items[0].id
    assert_equal 2, invoice.items[1].id
    assert_equal 2, invoice.items.count
  end

  def test_it_can_find_an_invoices_transactions
    invoice = @se_synthetic_data.invoices.find_by_id(1)
    assert_equal 1, invoice.transactions[0].id
    assert_equal 2, invoice.transactions[1].id
    assert_equal 2, invoice.transactions.count
    assert_equal "failed", invoice.transactions[1].result
    assert_equal "success", invoice.transactions[0].result
  end

  def test_it_can_find_an_invoices_customer
    invoice  = @se_synthetic_data.invoices.find_by_id(1)
    customer = invoice.customer

    assert_kind_of Customer, customer
    assert_equal 1, customer.id
  end

  def test_it_can_find_an_invoices_merchant
    invoice  = @se_synthetic_data.invoices.find_by_id(1)
    merchant = invoice.merchant

    assert_kind_of Merchant, merchant
    assert_equal 1, merchant.id
  end

  def test_it_can_find_a_transactions_invoice
    transaction = @se_synthetic_data.transactions.find_by_id(5)
    invoice     = transaction.invoice

    assert_equal 4, invoice.id
  end

  def test_it_can_find_a_merchants_customers
    merchant = @se_synthetic_data.merchants.find_by_id(1)
    customer = merchant.customers

    assert_equal 1, customer[0].id

    merchant = @se_synthetic_data.merchants.find_by_id(3)
    customers = merchant.customers

    customer_ids = customers.map do |customer|
      customer.id
    end

    assert customer_ids.include?(2)
    assert_equal 3, customers.length
  end

  def test_it_can_find_a_customers_merchants
    customer  = @se_synthetic_data.customers.find_by_id(1)
    merchants = customer.merchants

    merchant_ids = merchants.map do |merchant|
      merchant.id
    end

    assert merchant_ids.include?(1)
    assert_equal 2, merchants.count
  end

  def test_it_can_determine_if_an_invoice_has_been_paid_in_full
    invoice  = @se_synthetic_data.invoices.find_by_id(1)

    assert invoice.is_paid_in_full?
  end

  def test_it_can_find_the_total_balance_of_an_invoice
    invoice = @se_synthetic_data.invoices.find_by_id(1)
    total_balance = invoice.total

    assert_equal 875.0, total_balance
    assert_kind_of BigDecimal, total_balance
  end

  def test_a_merchant_can_find_its_revenues
    merchant = @se_synthetic_data.merchants.find_by_id(1)
    assert_equal 875, merchant.revenue
  end

end
