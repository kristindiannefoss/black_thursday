require 'minitest/autorun'
require 'minitest/pride'
# require_relative '../lib/merchant_repository'
# require_relative '../lib/merchant'
require_relative '../lib/invoice_repository'
require_relative '../lib/invoice'

class InvoiceRepositoryTest < Minitest::Test
  attr_reader :invoice1, :invoice2, :invoice3


  def setup
    @invoice1 = Invoice.new({id: 1,customer_id: 1,merchant_id: 12335938,status: "pending",created_at: "2009-02-07",updated_at: "2014-03-15"})
    @invoice2 = Invoice.new({id: 2,customer_id: 1,merchant_id: 12334753,status: "shipped",created_at: "2009-02-07",updated_at: "2014-03-15"})
    @invoice3 = Invoice.new({id: 3,customer_id: 2,merchant_id: 12334753,status: "pending",created_at: "2009-02-07",updated_at: "2014-03-15"})

    @invoices = [invoice1, invoice2, invoice3]

    @ir = InvoiceRepository.new(@invoices)
  end

  def test_an_instance_of_invoice_repository_can_be_created
    assert_kind_of InvoiceRepository, @ir
  end

  def test_it_can_find_all_invoices
    assert_equal @invoices, @ir.all
  end

  def test_it_can_find_an_invoice_by_its_id
    assert_equal invoice1, @ir.find_by_id(1)
  end

  def test_it_returns_nil_when_no_invoice_by_id_exists
    assert_nil @ir.find_by_id(7)
  end

  def test_it_can_find_by_customer_id
    assert_equal [invoice1, invoice2], @ir.find_all_by_customer_id(1)
  end

  def test_it_returns_an_empty_array_when_no_customer_id
    assert_equal [], @ir.find_all_by_customer_id(7)
  end

  def test_it_can_find_invoices_by_merchant_id
    assert_equal [invoice2, invoice3], @ir.find_all_by_merchant_id(12334753)
  end

  def test_it_returns_an_empty_array_when_no_merchant_id
    assert_equal [], @ir.find_all_by_merchant_id(7)
  end

  def test_it_can_find_all_by_status
    assert_equal [invoice1, invoice3], @ir.find_all_by_status("pending")
  end

  def test_it_returns_an_empty_array_when_no_status
    assert_equal [], @ir.find_all_by_status("fail")
  end



end

#se = SalesEngine.from_csv({:invoices => "./data/invoices.csv"})
# invoice = se.invoices.find_by_id(6)
# => <invoice>
