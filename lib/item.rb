require 'pry'

class Item
  attr_reader :id, :name, :description, :unit_price, :created_at, :updated_at

  def initialize(args)
    @id          = args[:id]
    @name        = args[:name]
    @description = args[:description]
    @unit_price  = args[:unit_price]
    @created_at  = args[:created_at]
    @updated_at  = args[:updated_at]
  end

  def unit_price_to_dollars
    (unit_price.to_f)/100
  end
end
