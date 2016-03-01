require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/item_repository'
require_relative '../lib/item'

class ItemRepositoryTest < Minitest::Test
  attr_reader :items, :item1, :item2
  def setup
    @item1 = Item.new({id: 263397785, name: "La prière", description: "Some long description", unit_price: 65000, merchant_id: 12334195, created_at: "2016-01-11 11:30:34 UTC", updated_at: "1987-05-07 03:18:42 UTC"})

    @item2 = Item.new({id: 263397843, name: "Wooden pen and stand", description: "Some other description", unit_price: 4000, merchant_id: 12334257, created_at: "2016-01-11 11:44:00 UTC", updated_at: "2006-08-26 06:56:21 UTC"})

    @item3 = Item.new({id: 263397846, name: "Crafty thing", description: "Super crafty you should buy this", unit_price: 65000, merchant_id: 12334257, created_at: "2016-01-11 11:44:00 UTC", updated_at: "2006-08-26 06:56:21 UTC"})

    @items  = [item1, item2]

    @ir = ItemRepository.new(items)
  end

  def test_it_can_be_created_with_new
    assert_kind_of ItemRepository, @ir
  end

  def test_it_can_find_all
    assert_equal @items, @ir.all
  end

  def test_it_can_find_by_id
    assert_equal @item1, @ir.find_by_id(263397785)
  end

  def test_it_returns_nil_when_id_does_not_exist
    assert_equal nil, @ir.find_by_id(5)
  end

  def test_it_can_find_by_name
    assert_equal @item2, @ir.find_by_name("La prière")
  end

  def test_it_returns_nil_when_no_name
    assert_equal nil, @ir.find_by_name("hghghg")
  end

  def test_it_can_find_all_with_a_description_fragment
    expected = [@item1, @item2]
    assert_equal expected, @ir.find_all_with_description("description")
  end

  def test_it_returns_an_empty_array_with_a_name_fragment_that_does_not_exist
    expected = []
    assert_equal expected, @ir.find_all_with_description("fail")
  end

  def test_it_can_find_all_by_price
    expected = [@item1, @item3]
    assert_equal expected, @ir.find_all_by_price(65000)
  end

  def test_it_returns_an_empty_array_for_a_price_that_does_not_exist
    expected = []
    assert_equal expected, @ir.find_all_by_price(8000)
  end

  def test_it_can_find_all_by_price_in_range
    expected = [@item1, @item3]
    assert_equal expected, @ir.find_all_by_price_in_range(62500, 67500)
  end

  def test_it_returns_an_empty_array_for_a_price_that_does_not_exist
    expected = []
    assert_equal expected, @ir.find_all_by_price_in_range(600, 625)
  end

end
