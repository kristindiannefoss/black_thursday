require 'pry'

class MerchantRepository
  attr_reader :merchants

  def initialize(merchants = [])
    @merchants = merchants
  end

  def all
    merchants
  end

  def find_by_id(id)
    merchants.detect { |merchant_object| merchant_object.id == id }
  end

  def find_by_name(name)
    merchants.detect { |merchant_object| merchant_object.name.downcase == name.downcase }
  end

  def find_all_by_name(name_fragment)
    merchants.select do |merchant_object|
      merchant_object.name.downcase.include?(name_fragment.downcase)
    end
  end

end
