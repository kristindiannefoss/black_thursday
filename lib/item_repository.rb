require 'pry'

class ItemRepository
  def initialize(items = [])
    @items = items
  end

  def all
    @items # returns an array of all known Item instances
  end

  def find_by_id(id)
    @items.detect do |item_object|
      item_object.id == id
    end
    # returns either nil or an instance of Item with a matching ID
  end

  def find_by_name(name)
    @items.detect do |item_object|
      item_object.name.downcase == name.downcase
    end
     # returns either nil or an instance of Item having done a case insensitive search
  end

  def find_all_with_description(description_fragment)
    @items.select do |item_object|
      item_object.description.downcase.include?(description_fragment.downcase)
    end
     # returns either [] or instances of Item where the supplied string appears in the item description (case insensitive)
  end

  def find_all_by_price(price)
    @items.select do |item_object|
      item_object.unit_price == price
    end
     # returns either [] or instances of Item where the supplied price exactly matches
  end

  def find_all_by_price_in_range(lowest_price, highest_price)
    @items.select do |item_object|
      item_object if lowest_price <= item_object.price && item_object.price <= highest_price
    end
     # returns either [] or instances of Item where the supplied price is in the supplied range (a single Ruby range instance is passed in)
  end

  def find_all_by_merchant_id
    @items.select do |item_object|
      item_object.merchant_id == merchant_id
    end
     # returns either [] or instances of Item where the supplied merchant ID matches that supplied
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
