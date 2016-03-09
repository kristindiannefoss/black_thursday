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
    inv_ids = repository.sales_engine.invoice_items.find_all_by_invoice_id(id)
    inv_ids.map do |invoice_item|
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
    transactions.any? {|transaction| transaction.result == "success"}
  end

  def total
    return 0 if is_paid_in_full? == false
    inv_ids = repository.sales_engine.invoice_items.find_all_by_invoice_id(id)
    inv_ids.map do |invoice_item|
      (invoice_item.unit_price * invoice_item.quantity)
    end.reduce(:+)
  end

  def is_pending?
    transactions.all? {|transaction| transaction.result == "failed"}
  end

  def items_and_counts
    items_and_counts = Hash.new(0)
    items.each do |item|
      in_itms = repository.sales_engine.invoice_items.find_all_by_invoice_id(id)

      in_itms.each do |invoice_item|
        items_and_counts[invoice_item.item] += invoice_item.quantity
      end
    end
    items_and_counts
  end

end
