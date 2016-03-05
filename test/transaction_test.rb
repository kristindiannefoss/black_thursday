require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/transaction'

class TransactionTest < Minitest::Test
  attr_reader :transaction

  def setup
    @transaction = Transaction.new({
                                    :id => 6,
                                    :invoice_id => 8,
                                    :credit_card_number => 4242424242424242,
                                    :credit_card_expiration_date => "0220",
                                    :result => "success",
                                    :created_at => "2012-02-26 20:56:58 UTC",
                                    :updated_at => "2012-02-26 20:56:58 UTC"
                                  })
  end

  def test_it_can_create_a_transaction_instance
    assert_kind_of Transaction, transaction
  end

  def test_it_returns_its_id
    assert_equal 6, @transaction.id
  end

  def test_it_returns_an_invoice_id
    assert_equal 8, @transaction.invoice_id
  end

  def test_it_returns_a_credit_card_number
    assert_equal 4242424242424242, @transaction.credit_card_number
  end

  def test_it_returns_a_credit_card_expiration_date
    assert_equal "0220", @transaction.credit_card_expiration_date
  end

  def test_it_returns_a_result
    assert_equal "success", @transaction.result
  end

  def test_it_returns_a_created_at
    assert_equal Time.parse("2012-02-26 20:56:58 UTC"), @transaction.created_at
  end

  def test_it_returns_an_updated_at
    assert_equal Time.parse("2012-02-26 20:56:58 UTC"), @transaction.updated_at
  end

end
