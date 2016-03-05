require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require_relative '../lib/invoice'

class InvoiceTest < Minitest::Test
  def setup
    @invoice = Invoice.new({
                :id          => 6,
                :customer_id => 7,
                :merchant_id => 8,
                :status      => "pending",
                :created_at  => "2014-03-15",
                :updated_at  => "2014-03-15",
    })
  end

  def test_it_can_be_initialized
    assert_kind_of Invoice, @invoice
  end

  def test_it_has_an_id
    assert_equal 6, @invoice.id
  end

  def test_it_has_a_customer_id
    assert_equal 7, @invoice.customer_id
  end

  def test_it_has_a_merchant_id
    assert_equal 8, @invoice.merchant_id
  end

  def test_it_has_a_status
    assert_equal :pending, @invoice.status
  end

  def test_it_has_a_created_at_time
    assert_equal Time.parse("2014-03-15"), @invoice.created_at
  end

  def test_it_has_a_updated_at_time
    assert_equal Time.parse("2014-03-15"), @invoice.updated_at
  end
end
