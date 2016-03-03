require 'pry'
require 'csv'
require 'bigdecimal'
require_relative 'merchant'
require_relative 'item'
require_relative 'invoice'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'

class SalesEngine
  attr_reader :merchants, :items, :invoices

  def initialize(merchants = nil, items = nil, invoices = nil)
    @merchants = merchants
    @items     = items
    @invoices  = invoices
  end

  def self.from_csv(args)
    items_array, merchants_array, invoices_array = read_all_csv(args)
    items_repo, merchants_repo, invoices_repo = create_repos(items_array, merchants_array, invoices_array)
    inject_repositories(merchants_repo, items_repo)

    SalesEngine.new(merchants_repo, items_repo)
  end

  def self.read_all_csv(args)
    [ make_objs(args[:items], Item),
      make_objs(args[:merchants], Merchant),
      make_objs(args[:invoices], Invoice)
    ]
  end

  def self.make_objs(location, class_type)
    read_one_csv(location).map do |item|
      class_type.new(item)
    end
  end

  def self.read_one_csv(csv_location)
    CSV.open(csv_location, headers: true, header_converters: :symbol)
  end

  def self.create_repos(items_array, merchants_array, invoices_array)
    [ItemRepository.new(items_array),
      MerchantRepository.new(merchants_array),
      InvoiceRepository.new(invoices_array)]
  end

  def self.inject_repositories(merchants_repo, items_repo)
    inject_merchants_repo(merchants_repo, items_repo)
    inject_items_repo(items_repo, merchants_repo)
  end

  def self.inject_merchants_repo(merchants_repo, items_repo)
    merchants_repo.all.each do |merchant|
      merchant.items = items_repo.find_all_by_merchant_id(merchant.id)
    end
  end

  def self.inject_items_repo(items_repo, merchants_repo)
    items_repo.all.each do |item|
      item.merchant = merchants_repo.find_by_id(item.merchant_id)
    end
  end

end
