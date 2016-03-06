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
    { items: ItemRepository.new(object_arrays[:items_array], sales_engine),
      merchants: MerchantRepository.new(object_arrays[:merchants_array], sales_engine),
      invoices: InvoiceRepository.new(object_arrays[:invoices_array], sales_engine),
      invoice_items: InvoiceItemRepository.new(object_arrays[:invoice_items_array], sales_engine),
      transactions: TransactionRepository.new(object_arrays[:transaction_array], sales_engine),
      customers: CustomerRepository.new(object_arrays[:customers_array], sales_engine)
    }
  end

end
