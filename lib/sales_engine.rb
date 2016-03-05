require 'pry'
require 'csv'
require 'bigdecimal'
require_relative 'merchant'
require_relative 'item'
require_relative 'invoice'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'

class SalesEngine
  attr_reader :merchants, :items, :invoices, :invoice_items

  def initialize(merchants = nil, items = nil, invoices = nil, invoice_items = nil)
    @merchants     = merchants
    @items         = items
    @invoices      = invoices
    @invoice_items = invoice_items
  end

  def self.from_csv(args)
    items_array, merchants_array, invoices_array, invoice_items_array = read_all_csv(args)
    items_repo, merchants_repo, invoices_repo, invoice_items_repo = create_repos(items_array, merchants_array, invoices_array, invoice_items_array)
    inject_repositories(merchants_repo, items_repo, invoices_repo, invoice_items_repo)

    SalesEngine.new(merchants_repo, items_repo, invoices_repo, invoice_items_repo)
  end

  def self.read_all_csv(args)
    [ make_objs(args[:items], Item),
      make_objs(args[:merchants], Merchant),
      make_objs(args[:invoices], Invoice),
      make_objs(args[:invoice_items], InvoiceItem)
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

  def self.inject_repositories(merchants_repo, items_repo, invoices_repo, invoice_items_repo)
    inject_merchants_repo(merchants_repo, items_repo, invoices_repo)
    inject_items_repo(items_repo, merchants_repo)
    inject_invoices_repo(invoices_repo, merchants_repo)
    inject_invoice_items_repo(invoice_items_repo, items_repo, invoices_repo)
  end

  def self.inject_merchants_repo(merchants_repo, items_repo, invoices_repo)
    merchants_repo.all.each do |merchant|
      merchant.items = items_repo.find_all_by_merchant_id(merchant.id)
      merchant.invoices = invoices_repo.find_all_by_merchant_id(merchant.id)
    end
  end

  def self.inject_items_repo(items_repo, merchants_repo)
    items_repo.all.each do |item|
      item.merchant = merchants_repo.find_by_id(item.merchant_id)
    end
  end

  def self.inject_invoices_repo(invoices_repo, merchants_repo)
    invoices_repo.all.each do |invoice|
      invoice.merchant = merchants_repo.find_by_id(invoice.merchant_id)
    end
  end

  def self.inject_invoice_items_repo(invoice_items_repo, items_repo, invoices_repo)
    invoice_items_repo.all.each do |invoice_item|
      invoice_item.items = items_repo.find_all_by_invoice_item_id(invoice_item.id)
      invoice_item.invoices = invoices_repo.find_all_by_invoice_item_id(invoice_item.id)
    end
  end
end
