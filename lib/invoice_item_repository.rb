require 'pry'

class InvoiceItemRepository
  attr_reader :invoice_items, :sales_engine

  def initialize(invoice_items = [], sales_engine)
    @invoice_items = invoice_items
    @sales_engine  = sales_engine
  end

  def all
    invoice_items
  end

  def find_by_id(id)
    invoice_items.detect { |invoice_item_object| invoice_item_object.id == id }
  end

  def find_all_by_item_id(item_id)
    invoice_items.select do |invoice_item_object|
      invoice_item_object.item_id == item_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    invoice_items.select do |invoice_item_object|
      invoice_item_object.invoice_id == invoice_id
    end
  end

  def inspect
  "#<#{self.class} #{@merchants.size} rows>"
  end
end
