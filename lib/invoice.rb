require 'pry'
require 'time'


class Invoice
  attr_accessor :repository
  attr_reader :id, :customer_id, :merchant_id, :status, :created_at, :updated_at

  def initialize(args)
    @id            = args[:id].to_i
    @customer_id   = args[:customer_id].to_i
    @merchant_id   = args[:merchant_id].to_i
    @status        = args[:status].to_sym
    @created_at    = Time.parse(args[:created_at])
    @updated_at    = Time.parse(args[:updated_at])
    @repository    = nil
  end

  def merchant
    repository.sales_engine.merchants.find_by_id(merchant_id)
  end

  def items
    repository.sales_engine.invoice_items.find_all_by_invoice_id(id).map do |invoice_item|
      repository.sales_engine.items.find_by_id(invoice_item.item_id)
    end
  end

  def transactions
    repository.sales_engine.transactions.find_all_by_invoice_id(id)
  end

  def customer
    repository.sales_engine.customers.find_by_id(customer_id)
  end

  def is_paid_in_full?
    transactions.any? do |transaction|
      transaction.result == "success"
    end
  end

  def total
    return 0 if is_paid_in_full? == false
    repository.sales_engine.invoice_items.find_all_by_invoice_id(id).map do |invoice_item|
      (invoice_item.unit_price * invoice_item.quantity)
    end.reduce(:+)
  end

  def is_pending?
    transactions.all? do |transaction|
      transaction.result == "failed"
    end
  end

  def items_and_counts
    #get a list of all the items from the invoice
    #get a list of the quantity for each item
    #put the items and quantities into a hash {item_id => quantity, item_2 => quantity}

    items_and_counts = Hash.new(0)
    items.each do |item|
      invoice_items = repository.sales_engine.invoice_items.find_all_by_invoice_id(id)

      invoice_items.each do |invoice_item|
        items_and_counts[invoice_item.item] += invoice_item.quantity
      end
    end
    items_and_counts
  end

end
