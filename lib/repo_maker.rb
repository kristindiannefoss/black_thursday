require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'transaction_repository'
require_relative 'customer_repository'

class RepoMaker
  attr_reader :sales_engine

  def initalize(sales_engine)
    @sales_engine = sales_engine
  end

  def create_repos(object_arrays)
    { items: ItemRepository.new(args[:items_array], sales_engine),
      merchants: MerchantRepository.new(args[:merchants_array], sales_engine),
      invoices: InvoiceRepository.new(args[:invoices_array], sales_engine),
      invoice_items: InvoiceItemRepository.new(args[:invoice_items_array], sales_engine),
      transactions: TransactionRepository.new(args[:transaction_array], sales_engine),
      customers: CustomerRepository.new(args[:customers_array], sales_engine)
    }
  end

  # def inject_repositories(merchants_repo, items_repo, invoices_repo, invoice_items_repo, transactions_repo, customer_repo)
  #   inject_merchants_repo(merchants_repo, items_repo, invoices_repo)
  #   inject_items_repo(items_repo, merchants_repo)
  #   inject_invoices_repo(invoices_repo, merchants_repo, invoice_items_repo, items_repo, transactions_repo, customer_repo)
  #   inject_transactions_repo(transactions_repo, invoices_repo)
  #   inject_merchant_customers(merchants_repo, invoices_repo, customer_repo)
  # end
  #
  # def inject_merchants_repo(merchants_repo, items_repo, invoices_repo)
  #   merchants_repo.all.each do |merchant|
  #     merchant.items     = items_repo.find_all_by_merchant_id(merchant.id)
  #     merchant.invoices  = invoices_repo.find_all_by_merchant_id(merchant.id)
  #   end
  # end
  #
  # def inject_merchant_customers(merchants_repo, invoices_repo, customer_repo)
  #   merchants_repo.all.each do |merchant|
  #     merchant_invoices = invoices_repo.find_all_by_merchant_id(merchant.id)
  #
  #     merchant.customers = merchant_invoices.map do |invoice|
  #       customer_repo.find_by_id(invoice.customer_id)
  #     end.uniq
  #   end
  # end
  #
  # def inject_items_repo(items_repo, merchants_repo)
  #   items_repo.all.each do |item|
  #     item.merchant = merchants_repo.find_by_id(item.merchant_id)
  #   end
  # end
  #
  # def inject_invoices_repo(invoices_repo, merchants_repo, invoice_items_repo, items_repo, transaction_repo, customer_repo)
  #   invoices_repo.all.each do |invoice|
  #     invoice.merchant    = inject_invoice_merchants(invoice, merchants_repo)
  #     invoice.items       = inject_invoice_items(invoice_items_repo, invoice, items_repo)
  #     invoice.transactions = inject_invoice_transactions(invoice, transaction_repo)
  #     invoice.customer    = inject_invoice_customer(invoice, customer_repo)
  #   end
  # end
  #
  # def inject_invoice_merchants(invoice, merchants_repo)
  #   merchants_repo.find_by_id(invoice.merchant_id)
  # end
  #
  # def inject_invoice_items(invoice_items_repo, invoice, items_repo)
  #   invoice_item_ids  = invoice_items_repo.find_all_by_invoice_id(invoice.id).map do |invoice_item|
  #     invoice_item.item_id
  #   end
  #   invoice_item_ids.map do |item_id|
  #     items_repo.find_by_id(item_id)
  #   end
  # end
  #
  # def inject_invoice_transactions(invoice, transactions_repo)
  #   transactions_repo.find_all_by_invoice_id(invoice.id)
  # end
  #
  # def inject_invoice_customer(invoice, customer_repo)
  #   customer_repo.find_by_id(invoice.customer_id)
  # end
  #
  # def inject_transactions_repo(transactions_repo, invoices_repo)
  #   transactions_repo.all.each do |transaction|
  #     transaction.invoice = invoices_repo.find_by_id(transaction.invoice_id)
  #   end
  # end

end
