require 'pry'
require 'time'

class SalesAnalyst
  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def average_items_per_merchant
    (sales_engine.items.count.to_f / sales_engine.merchants.count).round(2)
  end

  def average_items_per_merchant_standard_deviation
    av_it = average_items_per_merchant

    Math.sqrt(@sales_engine.merchants.all.map do |merchant|
      ((merchant.items.count) - av_it)**2
    end.reduce(:+)/@sales_engine.merchants.count).round(2)
  end

  def merchants_with_high_item_count
    minimum_count = average_items_per_merchant + average_items_per_merchant_standard_deviation

    @sales_engine.merchants.all.select do |merchant|
      merchant.items.count > minimum_count
    end
  end

  def average_item_price_for_merchant(merchant_id)
    current_merchant = @sales_engine.merchants.find_by_id(merchant_id)
    return 0 if current_merchant.items == []
    items_for_merchant = current_merchant.items
    (items_for_merchant.map do |item|
      item.unit_price
    end.reduce(:+)/items_for_merchant.count).round(2)
  end

  def average_average_price_per_merchant
    (@sales_engine.merchants.all.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end.reduce(:+)/@sales_engine.merchants.all.count).round(2)
  end

  def average_item_price
    @sales_engine.items.total_price / @sales_engine.items.count
  end

  def average_unit_price_standard_deviation
    av_price = average_item_price

    Math.sqrt(@sales_engine.items.all.map do |item|
      ((item.unit_price) - av_price)**2
    end.reduce(:+)/@sales_engine.items.count).round(2)
  end

  def golden_items
    min_price = average_item_price + (2 * average_unit_price_standard_deviation)
    @sales_engine.items.all.select do |item|
      item.unit_price > min_price
    end
  end

  def average_invoices_per_merchant
    (sales_engine.invoices.count.to_f / sales_engine.merchants.count).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    av_in = average_invoices_per_merchant

    Math.sqrt(@sales_engine.merchants.all.map do |merchant|
      ((merchant.invoices.count) - av_in)**2
    end.reduce(:+)/@sales_engine.merchants.count).round(2)
  end

  def top_merchants_by_invoice_count
    minimum_count = average_invoices_per_merchant + (average_invoices_per_merchant_standard_deviation * 2)

    @sales_engine.merchants.all.select do |merchant|
      merchant.invoices.count > minimum_count
    end
  end

  def bottom_merchants_by_invoice_count
    maximum_count = average_invoices_per_merchant - (average_invoices_per_merchant_standard_deviation * 2)

    @sales_engine.merchants.all.select do |merchant|
      merchant.invoices.count < maximum_count
    end
  end

  def average_invoices_per_day
    (sales_engine.invoices.count.to_f / 7).round(2)
  end

  def invoice_count_by_day
    invoices_by_date = @sales_engine.invoices.all.group_by do |invoice|
      invoice.created_at.strftime("%A")
    end

    hash_count = []
    invoices_by_date.each_pair do |key, value|
      hash_count << [key, value.count]
    end
    hash_count
  end

  def average_invoices_per_day_standard_deviation
    av_in = average_invoices_per_day
    invoices_by_day = invoice_count_by_day

    Math.sqrt(invoices_by_day.map do |day, invoices|
      (invoices - av_in)**2
    end.reduce(:+)/6).round(2)
  end

  def top_days_by_invoice_count
    minimum_count = average_invoices_per_day + (average_invoices_per_day_standard_deviation)

    # binding.pry

    high_sales_days = invoice_count_by_day.select do |day, count|
      count > minimum_count
    end

    high_sales_days.map do |days, count|
      days
    end
  end

end
