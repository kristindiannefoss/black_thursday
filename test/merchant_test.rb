require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchant'

class MerchantTest < Minitest::Test
  def test_it_can_be_created_with_new
    m = Merchant.new({:id => 5, :name => "Turing School", :created_at => "2010-12-10"})

    assert_kind_of Merchant, m
  end

  def test_it_can_return_merchant_id
    m = Merchant.new({:id => 5, :name => "Turing School", :created_at => "2010-12-10"})

    assert_equal 5, m.id
  end

  def test_it_can_return_merchant_name
    m = Merchant.new({:id => 5, :name => "Turing School", :created_at => "2010-12-10"})

    assert_equal "Turing School", m.name
  end
end
