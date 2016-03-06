require 'pry'
require 'time'


class Invoice
  attr_accessor :merchant, :items, :transactions, :customer
  attr_reader :id, :customer_id, :merchant_id, :status, :created_at, :updated_at

  def initialize(args)
    @id            = args[:id].to_i
    @customer_id   = args[:customer_id].to_i
    @merchant_id   = args[:merchant_id].to_i
    @status        = args[:status].to_sym
    @created_at    = Time.parse(args[:created_at])
    @updated_at    = Time.parse(args[:updated_at])
    @merchant      = nil
    @items         = nil
    @transactions  = nil
    @customer      = nil
  end

  def inspect
    "#<#{self.class}>"
  end

end
