require 'pry'
require 'csv'
require_relative 'merchant'
require_relative 'item'
require_relative 'item_repository'
require_relative 'merchant_repository'

class SalesEngine
  attr_reader :merchants, :items

  def initialize(merchants = nil, items = nil)
    items_array     = read_items(items) if items
    merchants_array = read_merchants(merchants) if merchants

    items_repo_object     = ItemRepository.new(items_array)
    merchants_repo_object = MerchantRepository.new(merchants_array)

    @merchants = merchants_repo_object
    @items     = items_repo_object
    # @merchants.all.each do |merchant|
    #   merchant.items = items.find_all_by_merchant_id(merchant.id)
    # end
  end

  def self.from_csv(args)
    new(args[:merchants], args[:items])
  end

  def read_items(location)
    items_csv = read_csv(location)
    items_array = []
    # binding.pry
    items_csv.each do |item|
      items_array << Item.new({id: item[:id],
                               name: item[:name],
                               description: item[:description],
                               unit_price: item[:unit_price],
                               created_at: item[:created_at],
                               updated_at: item[:updated_at]})
    end
    items_array
  end

  def read_merchants(location)
    merchants_csv  = read_csv(location)
    merchant_array = []
    merchants_csv.each do |merchant|
      merchant_array << Merchant.new({id: merchant[:id], name: merchant[:name]})
    end
    merchant_array
  end

  def read_csv(csv_location)
    CSV.open(csv_location, headers: true, header_converters: :symbol)
  end

end
