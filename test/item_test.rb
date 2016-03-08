require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'bigdecimal'
require 'time'
require_relative '../lib/item'

class ItemTest < Minitest::Test
  def setup
    @i = Item.new({
      :id          => "45254",
      :name        => "Pencil",
      :description => "You can use it to write things",
      :unit_price  => BigDecimal.new(1099,4),
      :created_at  => "2016-02-29 19:47:28 -0700",
      :updated_at  => "2016-02-29 19:47:28 -0700",
    })
  end

  def test_it_can_be_created_with_new
    assert_kind_of Item, @i
  end

  def test_it_returns_an_id
    assert_equal 45254, @i.id
  end

  def test_it_returns_a_name
    assert_equal "Pencil", @i.name
  end

  def test_it_returns_a_description
    assert_equal "You can use it to write things", @i.description
  end

  def test_it_returns_a_unit_price
    assert_equal 10.99, @i.unit_price
  end

  def test_it_returns_a_created_at
    assert_equal Time.parse("2016-02-29 19:47:28 -0700"), @i.created_at
  end

  def test_it_returns_an_updated_at
    assert_equal Time.parse("2016-02-29 19:47:28 -0700"), @i.updated_at
  end

  def test_it_returns_a_unit_price_in_dollars
    assert_equal 10.99, @i.unit_price_to_dollars
  end
end
