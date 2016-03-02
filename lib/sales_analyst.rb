class SalesAnalyst
  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def average_items_per_merchant
    sales_engine.items.count.to_f / sales_engine.merchants.count
  end

  def average_items_per_merchant_standard_deviation
    av_it = average_items_per_merchant

    Math.sqrt(@sales_engine.merchants.all.map do |merchant|
      ((merchant.items.count) - av_it)**2
    end.reduce(:+)/@sales_engine.merchants.count)
  end

  def merchants_with_high_item_count
    minimum_count = average_items_per_merchant + average_items_per_merchant_standard_deviation

    @sales_engine.merchants.all.select do |merchant|
      merchant.items.count > minimum_count
    end
  end
end
