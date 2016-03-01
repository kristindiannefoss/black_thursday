require 'pry'

class MerchantRepository
  def initialize(merchants)
    #returns an array of all known Merchant instances
  end

  def all
    #returns an array of all known Merchant instances
  end

  def find_by_id
    #returns either nil or an instance of Merchant
  end

  def find_by_name
    #returns either nil or an instance of Merchant having done a case insensitive search
  end

  def find_by_all_name
    #returns either [] or one or more matches which contain the supplied name fragment, case insensitive
  end

end
