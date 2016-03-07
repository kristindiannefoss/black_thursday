require 'pry'


class Merchant
  attr_accessor :repository
  attr_reader :id, :name

  def initialize(args)
    @id         = args[:id].to_i
    @name       = args[:name]
    @repository = nil
  end

  def items
    repository.sales_engine.items.find_all_by_merchant_id(id)
  end

  def invoices
    repository.sales_engine.invoices.find_all_by_merchant_id(id)
  end
end
