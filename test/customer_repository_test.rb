require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/customer_repository'
require_relative '../lib/customer'

class CustomerRepositoryTest < Minitest::Test
  attr_reader :customers, :customer1, :customer2, :customer3, :customer4, :customer5

  def setup
    @customer1 = Customer.new({id: 1, first_name: "Joey", last_name: "Ondricka", created_at: "2012-03-27 14:54:09 UTC", updated_at: "2012-03-27 14:54:09 UTC"})

    @customer2 = Customer.new({id: 2, first_name: "Cecelia", last_name: "Osinski", created_at: "2012-03-27 14:54:09 UTC", updated_at: "2012-03-27 14:54:09 UTC"})

    @customer3 = Customer.new({id: 3, first_name: "Mariah", last_name: "Toy", created_at: "2012-03-27 14:54:09 UTC", updated_at: "2012-03-27 14:54:09 UTC"})

    @customer4 = Customer.new({id: 4, first_name: "Ursher", last_name: "Osinski", created_at: "2012-03-27 14:54:09 UTC", updated_at: "2012-03-27 14:54:09 UTC"})

    @customer5 = Customer.new({id: 5, first_name: "Ursula", last_name: "Oshkosbgosh", created_at: "2012-03-27 14:54:09 UTC", updated_at: "2012-03-27 14:54:09 UTC"})

    @customers  = [customer1, customer2, customer3, customer4, customer5]

    @cr = CustomerRepository.new(customers)
  end

  def test_it_can_be_created_with_new
    assert_kind_of CustomerRepository, @cr
  end

  def test_it_can_find_all
    assert_equal @customers, @cr.all
  end

  def test_it_can_find_by_id
    assert_equal @customer1, @cr.find_by_id(1)
  end

  def test_it_returns_nil_when_id_does_not_exist
    assert_equal nil, @cr.find_by_id(9)
  end

  def test_it_can_find_all_by_first_name
    assert_equal [@customer1], @cr.find_all_by_first_name("Joey")
  end

  def test_it_can_find_all_by_first_name_fragment
    assert_equal [@customer1], @cr.find_all_by_first_name("Jo")

    assert_equal [@customer4, @customer5], @cr.find_all_by_first_name("Ur")
  end

  def test_it_returns_an_empty_array_when_no_name
    assert_equal [], @cr.find_all_by_first_name("Hobgobblin")
  end

  def test_it_can_find_all_by_last_name
    assert_equal [@customer2, @customer4], @cr.find_all_by_last_name("Osinski")
  end

  def test_it_can_find_all_by_last_name_fragment
    assert_equal [@customer2, @customer4, @customer5], @cr.find_all_by_last_name("Os")
  end
end
