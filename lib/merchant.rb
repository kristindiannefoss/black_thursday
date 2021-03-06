require 'pry'
require 'time'

class Merchant
  attr_accessor :repository
  attr_reader :id, :name, :created_at

  def initialize(args)
    @id         = args[:id].to_i
    @name       = args[:name]
    @created_at = Time.parse(args[:created_at])
    @repository = nil
  end

  def items
    repository.sales_engine.items.find_all_by_merchant_id(id)
  end

  def invoices
    repository.sales_engine.invoices.find_all_by_merchant_id(id)
  end

  def customers
    invoices.map {|invoice| invoice.customer}.uniq
  end

  def revenue
    merchant_inv = repository.sales_engine.invoices.find_all_by_merchant_id(id)
    merchant_inv.map {|invoice| invoice.total}.reduce(:+)
  end
end
