require 'pry'
require 'time'


class InvoiceItem
  # attr_accessor :item, :invoice
  attr_reader :id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at

  def initialize(args)
    @id            = args[:id].to_i
    @item_id       = args[:item_id].to_i
    @invoice_id    = args[:invoice_id].to_i
    @quantity      = args[:quantity].to_i
    @unit_price    = BigDecimal.new(args[:unit_price], 4)/100
    @created_at    = Time.parse(args[:created_at])
    @updated_at    = Time.parse(args[:updated_at])
  end

  def unit_price_to_dollars
    @unit_price
  end
end
