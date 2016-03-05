require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require 'bigdecimal'
require_relative '../lib/invoice_item'

class InvoiceItemTest < Minitest::Test
  def setup
    @invoice_item = InvoiceItem.new({
                :id          => 1,
                :item_id     => 263519844,
                :invoice_id  => 1,
                :quantity    => 5,
                :unit_price  => BigDecimal.new(13635, 4),
                :created_at  => "2012-03-27 14:54:09 UTC",
                :updated_at  => "2012-03-27 14:54:09 UTC",
    })
  end

  def test_it_can_be_initialized
    assert_kind_of InvoiceItem, @invoice_item
  end

  def test_it_has_an_id
    assert_equal 1, @invoice_item.id
  end

  def test_it_has_a_item_id
    assert_equal 263519844, @invoice_item.item_id
  end

  def test_it_has_a_invoice_id
    assert_equal 1, @invoice_item.invoice_id
  end

  def test_it_has_a_quantity
    assert_equal 5, @invoice_item.quantity
  end

  def test_it_has_a_created_at_time
    assert_equal Time.parse("2012-03-27 14:54:09 UTC"), @invoice_item.created_at
  end

  def test_it_has_a_updated_at_time
    assert_equal Time.parse("2012-03-27 14:54:09 UTC"), @invoice_item.updated_at
  end

  def test_it_returns_a_unit_price
    assert_equal 136.35, @invoice_item.unit_price
  end

  def test_it_returns_a_unit_price_in_dollars
    assert_equal 136.35, @invoice_item.unit_price_to_dollars
  end

end
