require 'pry'
require 'csv'
require 'bigdecimal'
require_relative 'object_maker'
require_relative 'repo_maker'


class SalesEngine
  attr_reader :merchants,
              :items,
              :invoices,
              :invoice_items,
              :transactions,
              :customers

  def initialize(repos = {})
    @merchants     = repos[:merchants]
    @items         = repos[:items]
    @invoices      = repos[:invoices]
    @invoice_items = repos[:invoice_items]
    @transactions  = repos[:transactions]
    @customers     = repos[:customers]
  end

  def self.from_csv(args)
    se = SalesEngine.new
    rm = RepoMaker.new(se)
    om = ObjectMaker.new

    object_arrays = om.read_all_csv(args)
    repos         = rm.create_repos(object_arrays)

    om.inject_objects(repos)

    return se
  end



  # def self.from_csv(args)
  #   items_array, merchants_array, invoices_array, invoice_items_array, transactions_array, customers_array = read_all_csv(args)
  #   items_repo, merchants_repo, invoices_repo, invoice_items_repo, transactions_repo, customer_repo = create_repos(items_array, merchants_array, invoices_array, invoice_items_array, transactions_array, customers_array)
  #   inject_repositories(merchants_repo, items_repo, invoices_repo, invoice_items_repo, transactions_repo, customer_repo)
  #
  #   SalesEngine.new(merchants_repo, items_repo, invoices_repo, invoice_items_repo, transactions_repo, customer_repo)
  # end

end
