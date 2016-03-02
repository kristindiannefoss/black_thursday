require 'pry'
require 'csv'
require 'bigdecimal'
require_relative 'merchant'
require_relative 'item'
require_relative 'item_repository'
require_relative 'merchant_repository'

class SalesEngine
  attr_reader :merchants, :items

  def initialize(merchants = nil, items = nil)
    @merchants = merchants
    @items     = items
  end

  def self.from_csv(args)
    items_array     = read_items(args[:items]) if args[:items]
    merchants_array = read_merchants(args[:merchants]) if args[:merchants]

    items_repo_object     = ItemRepository.new(items_array)
    merchants_repo_object = MerchantRepository.new(merchants_array)

    merchants_repo_object.all.each do |merchant|
      merchant.items = items_repo_object.find_all_by_merchant_id(merchant.id)
    end

    items_repo_object.all.each do |item|
      item.merchant = merchants_repo_object.find_by_id(item.merchant_id)
    end

    SalesEngine.new(merchants_repo_object, items_repo_object)
  end

  def self.read_items(location)
    items_csv = read_csv(location)
    items_array = []
    items_csv.each do |item|
      items_array << Item.new({id: item[:id],
                               name: item[:name],
                               description: item[:description],
                               unit_price: item[:unit_price],
                               merchant_id: item[:merchant_id],
                               created_at: item[:created_at],
                               updated_at: item[:updated_at]})
    end
    items_array
  end

  def self.read_merchants(location)
    merchants_csv  = read_csv(location)
    merchant_array = []
    merchants_csv.each do |merchant|
      merchant_array << Merchant.new({id: merchant[:id], name: merchant[:name]})
    end
    merchant_array
  end

  def self.read_csv(csv_location)
    CSV.open(csv_location, headers: true, header_converters: :symbol)
  end

end
