require 'pry'
require 'csv'
require 'bigdecimal'
require_relative 'merchant'
require_relative 'item'
require_relative 'invoice'
require_relative 'transaction'
require_relative 'item_repository'
require_relative 'invoice_item'
require_relative 'customer'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'transaction_repository'
require_relative 'customer_repository'

class SalesEngine
  attr_reader :merchants, :items, :invoices, :invoice_items, :transactions, :customers

  def initialize(merchants = nil, items = nil, invoices = nil, invoice_items = nil, transactions = nil, customers = nil)
    @merchants     = merchants
    @items         = items
    @invoices      = invoices
    @invoice_items = invoice_items
    @transactions  = transactions
    @customers     = customers
  end

  def self.from_csv(args)
    items_array, merchants_array, invoices_array, invoice_items_array, transactions_array, customers_array = read_all_csv(args)
    items_repo, merchants_repo, invoices_repo, invoice_items_repo, transactions_repo, customers_repo = create_repos(items_array, merchants_array, invoices_array, invoice_items_array, transactions_array, customers_array)
    inject_repositories(merchants_repo, items_repo, invoices_repo, invoice_items_repo, transactions_repo)

    SalesEngine.new(merchants_repo, items_repo, invoices_repo, invoice_items_repo, transactions_repo, customers_repo)
  end

  def self.read_all_csv(args)
    [ make_objs(args[:items], Item),
      make_objs(args[:merchants], Merchant),
      make_objs(args[:invoices], Invoice),
      make_objs(args[:invoice_items], InvoiceItem),
      make_objs(args[:transactions], Transaction),
      make_objs(args[:customers], Customer)
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

  def self.create_repos(items_array, merchants_array, invoices_array, invoice_items_array, transaction_array, customers_array)
    [ItemRepository.new(items_array),
      MerchantRepository.new(merchants_array),
      InvoiceRepository.new(invoices_array),
      InvoiceItemRepository.new(invoice_items_array),
      TransactionRepository.new(transaction_array),
      CustomerRepository.new(customers_array)]
  end

  def self.inject_repositories(merchants_repo, items_repo, invoices_repo, invoice_items_repo, transactions_repo)
    inject_merchants_repo(merchants_repo, items_repo, invoices_repo)
    inject_items_repo(items_repo, merchants_repo)
    inject_invoices_repo(invoices_repo, merchants_repo, invoice_items_repo)
    inject_transactions_repo(transactions_repo, invoices_repo)
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

  def self.inject_invoices_repo(invoices_repo, merchants_repo, invoice_items_repo)
    invoices_repo.all.each do |invoice|
      invoice.merchant = merchants_repo.find_by_id(invoice.merchant_id)
      invoice.items    = invoice_items_repo.find_all_by_invoice_id(invoice.id)
    end
  end

  def self.inject_transactions_repo(transactions_repo, invoices_repo)
    transactions_repo.all.each do |transaction|
      transaction.invoice = invoices_repo.find_by_id(transaction.invoice_id)
    end
  end

end
