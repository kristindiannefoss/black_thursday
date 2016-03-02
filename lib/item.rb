require 'pry'
require 'bigdecimal'
require 'time'

class Item
  attr_reader :id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at
  attr_accessor :merchant

  def initialize(args)
    @id          = args[:id].to_i
    @name        = args[:name]
    @description = args[:description]
    @unit_price  = BigDecimal.new(args[:unit_price], 4)/100
    @merchant_id = args[:merchant_id].to_i
    @created_at  = Time.parse(args[:created_at])
    @updated_at  = Time.parse(args[:updated_at])
    @merchant    = nil
  end

  def unit_price_to_dollars
    @unit_price
  end
end
