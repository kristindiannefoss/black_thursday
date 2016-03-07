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

    se.assign(repos)

    return se
  end

  def assign(repos)
    @items         = repos[0]
    @merchants     = repos[1]
    @invoices      = repos[2]
    @invoice_items = repos[3]
    @transactions  = repos[4]
    @customers     = repos[5]
  end

end
