require 'pry'

class InvoiceRepository
  attr_reader :invoices, :sales_engine

  def initialize(invoices = [], sales_engine)
    @invoices     = invoices
    @sales_engine = sales_engine
  end

  def all
    invoices
  end

  def count
    invoices.count
  end

  def count_by_status
    invoices_by_status = all.group_by do |invoice|
      invoice.status
    end

    status_count = invoices_by_status.each do |key, value|
      invoices_by_status[key] = value.count
    end
  end

  def find_by_id(id)
    invoices.detect { |invoice| invoice.id == id }
  end

  def find_all_by_customer_id(customer_id)
    invoices.select do |invoice|
      invoice.customer_id == customer_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    invoices.select do |invoice|
      invoice.merchant_id == merchant_id
    end
  end

  def find_all_by_status(status)
    invoices.select do |invoice|
      invoice.status == status
    end
  end

  def find_all_by_date(created_at)
    invoices.select do |invoice|
      invoice.created_at.strftime("%Y%m%d") == created_at.strftime("%Y%m%d")
    end
  end

  def find_all_pending
    invoices.select do |invoice|
      invoice.is_pending?
    end
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end
end
