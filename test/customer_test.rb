require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require_relative '../lib/customer'

class CustomerTest < Minitest::Test
  def setup
    @c = Customer.new({
               :id => 6,
       :first_name => "Joan",
        :last_name => "Clarke",
      :created_at  => "2016-02-29 19:47:28 -0700",
      :updated_at  => "2016-02-29 19:47:28 -0700",
    })
  end

  def test_it_can_be_created_with_new
    assert_kind_of Customer, @c
  end

  def test_it_returns_an_id
    assert_equal 6, @c.id
  end

  def test_it_returns_a_first_name
    assert_equal "Joan", @c.first_name
  end

  def test_it_returns_a_last_name
    assert_equal "Clarke", @c.last_name
  end

  def test_it_returns_a_created_at
    assert_equal Time.parse("2016-02-29 19:47:28 -0700"), @c.created_at
  end

  def test_it_returns_an_updated_at
    assert_equal Time.parse("2016-02-29 19:47:28 -0700"), @c.updated_at
  end
end
