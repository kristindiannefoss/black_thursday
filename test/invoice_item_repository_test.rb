require 'minitest/autorun'
require 'minitest/pride'
require 'bigdecimal'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/invoice_item'
require_relative '../lib/sales_engine'

class InvoiceItemRepositoryTest < Minitest::Test

  attr_reader :invoice_item1, :invoice_item2, :invoice_item3, :se
  
  def setup
      @invoice_item1 = InvoiceItem.new({id: 2,item_id: 263454779,invoice_id: 1,quantity: 9,unit_price: 23324, created_at: "2012-03-27 14:54:09 UTC",updated_at: "2012-03-27 14:54:09 UTC"})
      @invoice_item2 = InvoiceItem.new({id: 3,item_id: 263451719,invoice_id: 1,quantity: 8,unit_price:34873, created_at: "2012-03-27 14:54:09 UTC",updated_at: "2012-03-27 14:54:09 UTC"})
      @invoice_item3 = InvoiceItem.new({id: 4,item_id: 263542298,invoice_id: 2,quantity: 3,unit_price: 2196,created_at: "2012-03-27 14:54:09 UTC",updated_at: "2012-03-27 14:54:09 UTC"})
      @invoice_item4 = InvoiceItem.new({id: 5,item_id: 263542298,invoice_id: 3,quantity: 4,unit_price: 2196,created_at: "2012-03-27 14:54:09 UTC",updated_at: "2012-03-27 14:54:09 UTC"})

    @invoice_items = [invoice_item1, invoice_item2, invoice_item3, invoice_item3]
    @se            = SalesEngine.new

    @iir = InvoiceItemRepository.new(@invoice_items, se)
  end

  def test_an_instance_of_invoice_item_repository_can_be_created
    assert_kind_of InvoiceItemRepository, @iir
  end

  def test_it_can_find_all_invoice_items
    assert_equal @invoice_items, @iir.all
  end

  def test_it_can_find_an_invoice_item_by_its_id
    assert_equal invoice_item1, @iir.find_by_id(2)
  end

  def test_it_returns_nil_when_no_invoice_item_by_id_exists
    assert_nil @iir.find_by_id(7)
  end

  def test_it_can_find_by_item_id
    assert_equal [invoice_item2], @iir.find_all_by_item_id(263451719)
  end

  def test_it_returns_an_empty_array_when_no_item_id
    assert_equal [], @iir.find_all_by_item_id(263451717)
  end

  def test_it_can_find_by_invoice_id
    assert_equal [invoice_item1, invoice_item2], @iir.find_all_by_invoice_id(1)
  end

  def test_it_returns_an_empty_array_when_no_invoice_id
    assert_equal [], @iir.find_all_by_invoice_id(7)
  end
end
