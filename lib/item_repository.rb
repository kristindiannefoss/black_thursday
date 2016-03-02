require 'pry'

class ItemRepository
  attr_reader :items
  def initialize(items = [])
    @items = items
  end

  def all
    items
  end

  def count
    items.count
  end

  def find_by_id(id)
    items.detect do |item_object|
      item_object.id == id
    end
  end

  def find_by_name(name)
    items.detect do |item_object|
      item_object.name.downcase == name.downcase
    end
  end

  def find_all_with_description(description_fragment)
    items.select do |item_object|
      item_object.description.downcase.include?(description_fragment.downcase)
    end
  end

  def find_all_by_price(price)
    items.select do |item_object|
      item_object.unit_price == price
    end
  end

  def find_all_by_price_in_range(range)
    items.select do |item_object|
      item_object if range.include?(item_object.unit_price)
    end
  end

  def find_all_by_merchant_id(merchant_id)
    items.select do |item_object|
      item_object.merchant_id == merchant_id
    end
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

end

if __FILE__ == $0
  se = SalesEngine.from_csv({
    :items     => "./data/items.csv",
    :merchants => "./data/merchants.csv"
  })

  ir   = se.items
  item = ir.find_by_name("Item Repellat Dolorum") # => <Item>
end
