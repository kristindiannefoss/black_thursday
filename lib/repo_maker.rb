require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'transaction_repository'
require_relative 'customer_repository'

class RepoMaker
  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def create_repos(object_arrays)
    [
      ItemRepository.new(object_arrays[:items], sales_engine),
      MerchantRepository.new(object_arrays[:merchants], sales_engine),
      InvoiceRepository.new(object_arrays[:invoices], sales_engine),
      InvoiceItemRepository.new(object_arrays[:invoice_items], sales_engine),
      TransactionRepository.new(object_arrays[:transactions], sales_engine),
      CustomerRepository.new(object_arrays[:customers], sales_engine)
    ]
  end

end
