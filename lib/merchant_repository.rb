require 'pry'

class MerchantRepository
  def initialize(merchants = [])
    @merchants = merchants
  end

  def all
    @merchants
  end

  def find_by_id(id)
    @merchants.detect do |merchant_object|
      merchant_object.id == id
    end
  end

  def find_by_name(name)
    @merchants.detect do |merchant_object|
      merchant_object.name.downcase == name.downcase
    end
  end

  def find_all_by_name(name_fragment)
    @merchants.select do |merchant_object|
      merchant_object.name.downcase.include?(name_fragment.downcase)
    end
  end

end
