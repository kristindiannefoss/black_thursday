require 'pry'

class Merchant
  attr_reader :id, :name
  # attr_accessor :items

  def initialize(args)
    @id   = args[:id] #{:id => "somevalue"}
    @name = args[:name]
  end
end
