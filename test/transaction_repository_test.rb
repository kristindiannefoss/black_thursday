require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/transaction_repository'

class TransactionRepositoryTest < Minitest::Test
  attr_reader :tr

  def setup
    @tr = TransactionRepository.new
    tr.from_csv("./test/test_data/transactions_stub.csv")
  end

  def test_it_can_create_a_transaction_repository_instance
    assert_kind_of TransactionRepository, tr
  end

  def test_it_can_return_all_transaction_instances
    assert_equal 25, tr.all.length
    assert_kind_of Transaction, tr.all[0]
  end

  def test_it_can_find_transactions_by_id
    assert_equal nil, tr.find_by_id(1)
    assert_kind_of Transaction, tr.find_by_id(1408)
  end

  def test_it_can_find_all_by_invoice_id
    assert_equal [], tr.find_all_by_invoice_id(1)
    assert_equal 2, tr.find_all_by_invoice_id(3744).length
    assert_kind_of Transaction, tr.find_all_by_invoice_id(3744)[1]
  end

  def test_it_can_find_all_by_credit_card_number
    assert_equal [], tr.find_all_by_credit_card_number("1")
    assert_equal 3, tr.find_all_by_credit_card_number("4575593485193657").length
    assert_kind_of Transaction, tr.find_all_by_credit_card_number("4575593485193657")[0]
  end

  def test_it_can_find_all_by_result
    assert_equal [], tr.find_all_by_result("1")
    assert_equal 5, tr.find_all_by_result("failed").length
    assert_kind_of Transaction, tr.find_all_by_result("failed")[3]
  end

end
