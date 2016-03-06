require 'pry'
require 'csv'
require 'bigdecimal'
require_relative 'merchant'
require_relative 'item'
require_relative 'invoice'
require_relative 'transaction'
require_relative 'item_repository'
require_relative 'invoice_item'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'transaction_repository'

class SalesEngine
  attr_reader :merchants, :items, :invoices, :invoice_items, :transactions

  def initialize(args)
    @merchants     = args[:merchants]
    @items         = args[:items]
    @invoices      = args[:invoices]
    @invoice_items = args[:invoice_items]
    @transactions  = args[:transactions]
  end

  def self.from_csv(args)
    csv_arrays = read_all_csv(args)
    repos = create_repos(csv_arrays)
    inject_repositories(repos)

    SalesEngine.new(repos)
  end

  def self.read_all_csv(args)
    [ make_objs(args[:items], Item),
      make_objs(args[:merchants], Merchant),
      make_objs(args[:invoices], Invoice),
      make_objs(args[:invoice_items], InvoiceItem),
      make_objs(args[:transactions], Transaction)
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

  def self.create_repos(csv_arrays)
    [ ItemRepository.new(csv_arrays[:items]),
      MerchantRepository.new(csv_arrays[:merchants]),
      InvoiceRepository.new(csv_arrays[:invoices]),
      InvoiceItemRepository.new(csv_arrays[:invoice_items]),
      TransactionRepository.new(csv_arrays[:transaction])
    ]
  end

  def self.inject_repositories(repos)
    inject_merchants_repo(repos)
    inject_items_repo(repos)
    inject_invoices_repo(repos)
    inject_transactions_repo(repos)
  end

  def self.inject_merchants_repo(repos)
    repos[:merchants].all.each do |merchant|
      merchant.items = repos[:items].find_all_by_merchant_id(merchant.id)
      merchant.invoices = repos[:invoices].find_all_by_merchant_id(merchant.id)
    end
  end

  def self.inject_items_repo(repos)
    repos[:items].all.each do |item|
      item.merchant = repos[:merchants].find_by_id(item.merchant_id)
    end
  end

  def self.inject_invoices_repo(repos)
    repos[:invoices].all.each do |invoice|
      invoice.merchant = repos[:merchants].find_by_id(invoice.merchant_id)
      invoice.items    = repos[:invoice_items].find_all_by_invoice_id(invoice.id)
    end
  end

  def self.inject_transactions_repo(repos)
    repos[:transactions].all.each do |transaction|
      transaction.invoice = invoices_repo.find_by_id(transaction.invoice_id)
    end
  end

end
