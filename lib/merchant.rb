require 'pry'


class Merchant
  attr_accessor :merchants
  attr_reader :id, :name

  def initialize(args)
    @id        = args[:id].to_i
    @name      = args[:name]
    @merchants = nil
  end
end
