require_relative 'merchant'
require_relative 'item'
require_relative 'invoice'
require_relative 'transaction'
require_relative 'invoice_item'
require_relative 'customer'

class ObjectMaker
  def initalize

  end

  def read_all_csv(args)
    { items: make_objs(args[:items], Item),
      merchants: make_objs(args[:merchants], Merchant),
      invoices: make_objs(args[:invoices], Invoice),
      invoice_items: make_objs(args[:invoice_items], InvoiceItem),
      transactions: make_objs(args[:transactions], Transaction),
      customers: make_objs(args[:customers], Customer)
    }
  end

  def make_objs(location, class_type)
    read_one_csv(location).map do |item|
      class_type.new(item)
    end
  end

  def read_one_csv(csv_location)
    CSV.open(csv_location, headers: true, header_converters: :symbol)
  end

  def inject_objects(repos)
    repos.each do |repo|
      repo.all.each {|object| object.repository = repo }
    end
  end

end
