require_relative 'transaction'
require 'csv'

class TransactionRepository
  attr_reader :transactions

  def initialize(transactions = [])
    @transactions = transactions
  end

  def from_csv(csv_location)
    transactions_csv = CSV.open(csv_location,
                                headers: true,
                                header_converters: :symbol)

    @transactions = transactions_csv.map do
       |transaction| Transaction.new(transaction)
    end
  end

  def all
    transactions
  end

  def find_by_id(transaction_id)
    transactions.detect { |transaction| transaction_id == transaction.id}
  end

  def find_all_by_invoice_id(invoice_id)
    transactions.select { |transaction| invoice_id == transaction.invoice_id}
  end

  def find_all_by_credit_card_number(cc_number)
    transactions.select { |trans| cc_number == trans.credit_card_number}
  end

  def find_all_by_result(result)
    transactions.select { |trans| result == trans.result}
  end

end
