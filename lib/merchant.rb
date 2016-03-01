require 'pry'

class Merchant
  def id
    #returns the integer id of the merchant
  end

  def name
    #returns the name of the merchant
  end
end


if __FILE__ == $0
  m = Merchant.new({:id => 5, :name => "Turing School"})
  puts m.id
  puts m.name
end
