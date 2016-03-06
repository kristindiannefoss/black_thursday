require 'time'

class Customer
  attr_reader :id, :first_name, :last_name, :created_at, :updated_at
  attr_accessor :invoices, :items

  def initialize(args)
    @id          = args[:id].to_i
    @first_name  = args[:first_name]
    @last_name   = args[:last_name]
    @created_at  = Time.parse(args[:created_at])
    @updated_at  = Time.parse(args[:updated_at])
    @invoices    = nil
    @items       = nil
  end

  def inspect
    "#<#{self.class}>"
  end
end
