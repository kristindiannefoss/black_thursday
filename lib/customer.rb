require 'time'

class Customer
  attr_reader :id, :first_name, :last_name, :created_at, :updated_at
  attr_accessor :repository

  def initialize(args)
    @id          = args[:id].to_i
    @first_name  = args[:first_name]
    @last_name   = args[:last_name]
    @created_at  = Time.parse(args[:created_at])
    @updated_at  = Time.parse(args[:updated_at])
    @repository  = nil
  end

  def merchants
    invoices = repository.sales_engine.invoices.find_all_by_customer_id(id)
    merchant_ids = invoices.map do |invoice|
      invoice.merchant_id
    end

    merchant_ids.map do |merchant_id|
      repository.sales_engine.customers.find_by_id(merchant_id)
    end
  end
end
