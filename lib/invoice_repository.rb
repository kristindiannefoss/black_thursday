require 'pry'

class InvoiceRepository
  attr_reader :invoices

  def initialize(invoices= [])
    @invoices = invoices
  end

  def all
    invoices
  end

  def find_by_id(id)
    invoices.detect { |invoice_object| invoice_object.id == id }
  end

  def find_all_by_customer_id(customer_id)
    invoices.select do |invoice_object|
      invoice_object.customer_id == customer_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    invoices.select do |invoice_object|
      invoice_object.merchant_id == merchant_id
    end
  end

  def find_all_by_status(status)
    invoices.select do |invoice_object|
      invoice_object.status == status
    end
  end
end
