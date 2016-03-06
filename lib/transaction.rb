require 'time'

class Transaction
  attr_accessor :invoice

  attr_reader :id,
              :invoice_id,
              :credit_card_number,
              :credit_card_expiration_date,
              :result,
              :created_at,
              :updated_at

  def initialize(args)
    @id                          = args[:id].to_i
    @invoice_id                  = args[:invoice_id].to_i
    @credit_card_number          = args[:credit_card_number].to_i
    @credit_card_expiration_date = args[:credit_card_expiration_date]
    @result                      = args[:result]
    @created_at                  = Time.parse(args[:created_at])
    @updated_at                  = Time.parse(args[:updated_at])
    @invoice                     = nil
  end

  def inspect
    "#<#{self.class}>"
  end

end
