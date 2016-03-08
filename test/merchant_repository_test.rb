require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchant_repository'
require_relative '../lib/merchant'
require_relative '../lib/sales_engine'

class MerchantRepositoryTest < Minitest::Test
  attr_reader :merchants, :merchant1, :merchant2, :merchant3, :merchant4, :se

  def setup
    @merchant1 = Merchant.new({id: 12335099, name: "silvia2knit"})
    @merchant2 = Merchant.new({id: 12335101, name: "TinyHatsbyHG"})
    @merchant3 = Merchant.new({id: 12335104, name: "AdventureEmporium"})
    @merchant4 = Merchant.new({id: 12335105, name: "AdventurehatsEmporium"})

    @merchants  = [merchant1, merchant2, merchant3, merchant4]

    @se = SalesEngine.new
    @mr = MerchantRepository.new(merchants, se)
  end

  def test_it_can_be_created_with_new
    assert_kind_of MerchantRepository, @mr
  end

  def test_it_can_find_all
    assert_equal @merchants, @mr.all
  end

  def test_it_can_find_by_id
    assert_equal @merchant1, @mr.find_by_id(12335099)
  end

  def test_it_returns_nil_when_id_does_not_exist
    assert_equal nil, @mr.find_by_id(5)
  end

  def test_it_can_find_by_name
    assert_equal @merchant2, @mr.find_by_name("TinyHatsbyHG")
  end

  def test_it_returns_nil_when_no_name
    assert_equal nil, @mr.find_by_name("byHG")
  end

  def test_it_can_find_all_with_a_name_fragment
    expected = [@merchant2, @merchant4]
    assert_equal expected, @mr.find_all_by_name("hats")
  end

  def test_it_returns_an_empty_array_with_a_name_fragment_that_does_not_exist
    expected = []
    assert_equal expected, @mr.find_all_by_name("fail")
  end
end
