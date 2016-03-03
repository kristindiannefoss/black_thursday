require 'pry'


class Merchant
  attr_accessor :items
  attr_reader :id, :name

  def initialize(args)
    @id   = args[:id].to_i
    @name = args[:name]
    @items = nil
  end
end
