require 'pry'
require 'merchant'
require 'item'

class SalesEngine
  attr_reader :merchants, :items

  def initialize(merchants = nil, items = nil)
    @merchants = merchants
    @items     = items
  end

  def self.from_csv(args_hash)
    items_array     = read_items(args[:items]) if args[:items]
    merchants_array = read_merchants(args[:merchants]) if args[:merchants]

    items_repo_object     = ItemRepository.new(items_array)
    merchants_repo_object = MerchantRepository.new(merchants_array)

    sales_engine    = SalesEngine.new(merchants_repo_object, items_repo_object)
  end

  def self.read_items(location)
    items_csv = read_csv(location)
    items_array = []
    items_csv.each do |item|
      items_array << Item.new({id: merchant[:id],
                               name: merchant[:name],
                               description: merchant[:description],
                               unit_price: merchant[:unit_price],
                               created_at: merchant[:created_at],
                               updated_at: merchant[:updated_at]})
    end
    items_array
  end

  def self.read_merchants(location)
    merchants_csv  = read_csv(location)
    merchant_array = []
    merchants_csv.each do |merchant|
      merchants_array << Merchant.new({id: merchant[:id], name: merchant[:name]})
    end
    merchants_array
  end

  def self.read_csv(csv_location)
    CSV.open(csv_location, headers: true, header_converters: :symbol)
  end

end
