require 'pry'

class MerchantRepository
  def initialize
  end

  def all
  end

  def find_by_id
    #returns an array of all known Merchant instances
  end

  def find_by_name
    #returns either nil or an instance of Merchant
  end

  def find_by_all_name
    #returns either [] or one or more matches which contain the supplied name fragment, case insensitive
  end

end
