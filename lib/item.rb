require 'pry'

class Item
  def initialize
  end

  def id
    #returns the integer id of the item
  end

  def name
    #returns the name of the item
  end

  def description
    #- returns the description of the item
  end

  def unit_price
    #- returns the price of the item formatted as a BigDecimal
  end

  def created_at
    # - returns a Time instance for the date the item was first created
  end

  def updated_at
    # - returns a Time instance for the date the item was last modified
  end

  def merchant_id
    # - returns the integer merchant id of the item
  end

  def unit_price_to_dollars
    # - returns the price of the item in dollars formatted as a Float
  end
end
