# require_relative 'customer'
require 'pry'

class CustomerRepository
  attr_reader :customers

  def initialize(customers = [])
    @customers = customers
  end

  def all
    customers
  end

  def find_by_id(id)
    customers.detect { |customer_object| customer_object.id == id }
  end

  def find_all_by_first_name(first_name_fragment)
    customers.select do |customer_object|
    customer_object.first_name.downcase.include?(first_name_fragment.downcase)
    end
  end

  def find_all_by_last_name(last_name_fragment)
    customers.select do |customer_object|
    customer_object.last_name.downcase .include?(last_name_fragment.downcase)
    end
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end
end
