# Black Thursday

A business is only as smart as its data. Let's build a system able to load, parse, search, and execute business intelligence queries against the data from a typical e-commerece business.

## Project Overview

### Learning Goals

* Use tests to drive both the design and implementation of code
* Decompose a large application into components
* Use test fixtures instead of actual data when testing
* Connect related objects together through references
* Learn an agile approach to building software

### Getting Started

1. One team member forks the repository at https://github.com/turingschool-examples/black_thursday and adds the other(s) as collaborators.
2. Everyone on the team clones the repository
3. Create a [Waffle.io](http://waffle.io) account for project management.
4. Setup [CodeClimate](https://codeclimate.com/) to monitor code quality along the way
5. Setup [TravisCI](https://travis-ci.org/) to run your tests ever time you push

### Spec Harness

This project will be assessed with the help of a [spec harness](https://github.com/turingschool/black_thursday_spec_harness). The `README.md` file includes instructions for setup and usage. Note that the spec harness **is not** a replacement for your own test suite.

## Key Concepts

From a technical perspective, this project will emphasize:

* File I/O
* Relationships between objects
* Encapsulating Responsibilities
* Light data / analytics

## Project Iterations and Base Expectations

Because the requirements for this project are lengthy and complex, we've broken
them into Iterations in their own files. Your project *must* implement iterations 0 through 3.

* [Iteration 0](black_thursday/iteration_0.markdown) - Merchants & Items
* [Iteration 1](black_thursday/iteration_1.markdown) - Beginning Relationships and Business Intelligence (*pending*)
* [Iteration 2](black_thursday/iteration_2.markdown) - Basic Invoices
* [Iteration 3](black_thursday/iteration_3.markdown) - Item Sales
* [Iteration 4](black_thursday/iteration_4.markdown) - Merchant Analytics
* [Iteration 5](black_thursday/iteration_5.markdown) - Customer Analytics

## Evaluation Rubric

The project will be assessed with the following guidelines:

### 1. Functional Expectations

* 4: Application implements iterations 0, 1, 2, 3, (4 or 5), and features of your own design
* 3: Application implements iterations 0, 1, 2, 3, and either 4 or 5
* 2: Application implements iterations 0, 1, 2, and 3
* 1: Application does not fully implement iterations 0, 1, 2, and 3

### 2. Test-Driven Development

* 4: Application is broken into components which are well tested in both isolation and integration using appropriate data
* 3: Application is well tested but does not balance isolation and integration tests, using only the data necessary to test the functionality
* 2: Application makes some use of tests, but the coverage is insufficient
* 1: Application does not demonstrate strong use of TDD

### 3. Encapsulation / Breaking Logic into Components

* 4: Application is expertly divided into logical components each with a clear, single responsibility
* 3: Application effectively breaks logical components apart but breaks the principle of SRP
* 2: Application shows some effort to break logic into components, but the divisions are inconsistent or unclear
* 1: Application logic shows poor decomposition with too much logic mashed together

### 4. Fundamental Ruby & Style

* 4:  Application demonstrates excellent knowledge of Ruby syntax, style, and refactoring
* 3:  Application shows strong effort towards organization, content, and refactoring
* 2:  Application runs but the code has long methods, unnecessary or poorly named variables, and needs significant refactoring
* 1:  Application generates syntax error or crashes during execution

### 5. Enumerable & Collections

* 4: Application consistently makes use of the best-choice Enumerable methods
* 3: Application demonstrates comfortable use of appropriate Enumerable methods
* 2: Application demonstrates functional knowledge of Enumerable but only uses the most basic techniques
* 1: Application demonstrates deficiencies with Enumerable and struggles with collections

### 6. Code Sanitation

The output from `rake sanitation:all` shows...

* 4: Zero complaints
* 3: Five or fewer complaints
* 2: Six to ten complaints
* 1: More than ten complaints




# Iteration 0 - Merchants & Items

The goal of this iteration is to get the ball rolling by focusing on a "Data Access Layer" for multiple CSV files.

## Data Access Layer

The idea of a *DAL* is to write classes which load and parse your raw data, allowing your system to then interact with rich ruby objects to do more complex analysis. In this iteration we'll build the beginnings of a DAL by building the classes described below:

### `SalesEngine`

Then let's tie everything together with one common root, a `SalesEngine` instance:

```ruby
se = SalesEngine.from_csv({
  :items     => "./data/items.csv",
  :merchants => "./data/merchants.csv",
})
```

From there we can find the child instances:

* `items` returns an instance of `ItemRepository` with all the item instances loaded
* `merchants` returns an instance of `MerchantRepository` with all the merchant instances loaded

### `MerchantRepository`

The `MerchantRepository` is responsible for holding and searching our `Merchant`
instances. It offers the following methods:

* `all` - returns an array of all known `Merchant` instances
* `find_by_id` - returns either `nil` or an instance of `Merchant` with a matching ID
* `find_by_name` - returns either `nil` or an instance of `Merchant` having done a *case insensitive* search
* `find_all_by_name` - returns either `[]` or one or more matches which contain the supplied name fragment, *case insensitive*

The data can be found in `data/merchants.csv` so the instance is created and used like this:

```ruby
se = SalesEngine.from_csv({
  :items     => "./data/items.csv",
  :merchants => "./data/merchants.csv",
})

mr = se.merchants
merchant = mr.find_by_name("CJsDecor")
# => <Merchant>
```

### `Merchant`

The merchant is one of the critical concepts in our data hierarchy.

* `id` - returns the integer id of the merchant
* `name` - returns the name of the merchant

We create an instance like this:

```ruby
m = Merchant.new({:id => 5, :name => "Turing School"})
```

### `ItemRepository`

The `ItemRepository` is responsible for holding and searching our `Item`
instances. This object represents one line of data from the file `items.csv`.

It offers the following methods:

* `all` - returns an array of all known `Item` instances
* `find_by_id` - returns either `nil` or an instance of `Item` with a matching ID
* `find_by_name` - returns either `nil` or an instance of `Item` having done a *case insensitive* search
* `find_all_with_description` - returns either `[]` or instances of `Item` where the supplied string appears in the item description (case insensitive)
* `find_all_by_price` - returns either `[]` or instances of `Item` where the supplied price exactly matches
* `find_all_by_price_in_range` - returns either `[]` or instances of `Item` where the supplied price is in the supplied range (a single Ruby `range` instance is passed in)
* `find_all_by_merchant_id` - returns either `[]` or instances of `Item` where the supplied merchant ID matches that supplied

It's initialized and used like this:

```ruby
se = SalesEngine.from_csv({
  :items     => "./data/items.csv",
  :merchants => "./data/merchants.csv"
})

ir   = se.items
item = ir.find_by_name("Item Repellat Dolorum")
# => <Item>
```

### `Item`

The Item instance offers the following methods:

* `id` - returns the integer id of the item
* `name` - returns the name of the item
* `description` - returns the description of the item
* `unit_price` - returns the price of the item formatted as a `BigDecimal`
* `created_at` - returns a `Time` instance for the date the item was first created
* `updated_at` - returns a `Time` instance for the date the item was last modified
* `merchant_id` - returns the integer merchant id of the item

It also offers the following method:

* `unit_price_to_dollars` - returns the price of the item in dollars formatted as a `Float` 

We create an instance like this:

```ruby
i = Item.new({
  :name        => "Pencil",
  :description => "You can use it to write things",
  :unit_price  => BigDecimal.new(10.99,4),
  :created_at  => Time.now,
  :updated_at  => Time.now,
})
```





# Iteration 1 - Starting Relationships and Business Intelligence

With the beginnings of a Data Access Layer in place we can begin building relationships between objects and derive some business intelligence.

## Starting the Relationships Layer

Merchants and Items are linked conceptually by the `merchant_id` in `Item` corresponding to the `id` in `Merchant`. Connect them in code to allow for the following interaction:

```ruby
se = SalesEngine.from_csv({
  :items     => "./data/items.csv",
  :merchants => "./data/merchants.csv",
})
merchant = se.merchants.find_by_id(10)
merchant.items
# => [<item>, <item>, <item>]
item = se.items.find_by_id(20)
item.merchant
# => <merchant>
```

## Starting the Analysis Layer

Our analysis will use the data and relationships to calculate information.

Who in the system will answer those questions? Assuming we have a `se` that's an instance of `SalesEngine` let's initialize a `SalesAnalyst` like this:

```ruby
sa = SalesAnalyst.new(se)
```

Then ask/answer these questions:

### How many products do merchants sell?

Do most of our merchants offer just a few items or do they represent a warehouse?

```ruby
sa.average_items_per_merchant # => 2.88
```

And what's the standard deviation?

```ruby
sa.average_items_per_merchant_standard_deviation # => 3.26
```

### Note on Standard Deviations

There are two ways for calculating standard deviations -- for a population and for a sample.

For this project, use the sample standard deviation.

As an example, given the set `3,4,5`. We would calculate the deviation using the following steps:

1. Take the difference between each number and the mean and square it
2. Sum these square differences together
3. Divide the sum by the number of elements minus 1
4. Take the square root of this result

Or, in pseudocode:

```
set = [3,4,5]

std_dev = sqrt( ( (3-4)^2+(4-4)^2+(5-4)^2 ) / 2 )
```

### Which merchants sell the most items?

Maybe we could set a good example for our lower sellers by displaying the merchants who have the most items for sale. Which merchants are more than one standard deviation above the average number of products offered?

```ruby
sa.merchants_with_high_item_count # => [merchant, merchant, merchant]
```

### What are prices like on our platform?

Are these merchants selling commodity or luxury goods? Let's find the average price of a merchant's items (by supplying the merchant ID):

```ruby
sa.average_item_price_for_merchant(6) # => BigDecimal
```

Then we can sum all of the averages and find the average price across all merchants (this implies that each merchant's average has equal weight in the calculation): 

```ruby
sa.average_average_price_per_merchant # => BigDecimal
```

### Which are our *Golden Items*?

Given that our platform is going to charge merchants based on their sales, expensive items are extra exciting to us. Which are our "Golden Items", those two standard-deviations above the average item price? Return the item objects of these "Golden Items".

```ruby
sa.golden_items # => [<item>, <item>, <item>, <item>]
```





# I2: Basic Invoices

Now we'll begin to move a little faster. Let's work with invoices and build up the data access layer, relationships, and business intelligence in one iteration.

## Data Access Layer

### `InvoiceRepository`

The `InvoiceRepository` is responsible for holding and searching our `Invoice`
instances. It offers the following methods:

* `all` - returns an array of all known `Invoice` instances
* `find_by_id` - returns either `nil` or an instance of `Invoice` with a matching ID
* `find_all_by_customer_id` - returns either `[]` or one or more matches which have a matching customer ID
* `find_all_by_merchant_id` - returns either `[]` or one or more matches which have a matching merchant ID
* `find_all_by_status` - returns either `[]` or one or more matches which have a matching status

The data can be found in `data/invoices.csv` so the instance is created and used like this:

```ruby
se = SalesEngine.from_csv({:invoices => "./data/invoices.csv"})
invoice = se.invoices.find_by_id(6)
# => <invoice>
```

### `Invoice`

The invoice has the following data accessible:

* `id` - returns the integer id
* `customer_id` - returns the customer id
* `merchant_id` - returns the merchant id
* `status` - returns the status
* `created_at` - returns a `Time` instance for the date the item was first created
* `updated_at` - returns a `Time` instance for the date the item was last modified

We create an instance like this:

```ruby
i = Invoice.new({
  :id          => 6,
  :customer_id => 7,
  :merchant_id => 8,
  :status      => "pending",
  :created_at  => Time.now,
  :updated_at  => Time.now,
})
```

## Relationships

Then connect our invoices to our merchants:

```ruby
se = SalesEngine.from_csv({
  :items => "./data/items.csv",
  :merchants => "./data/merchants.csv",
  :invoices => "./data/invoices.csv"
})
merchant = se.merchants.find_by_id(10)
merchant.invoices
# => [<invoice>, <invoice>, <invoice>]
invoice = se.invoices.find_by_id(20)
invoice.merchant
# => <merchant>
```

## Business Intelligence

Assume we're created `sa` as a `SalesAnalyst` instance:

### How many invoices does the average merchant have?

```ruby
sa.average_invoices_per_merchant # => 8.5
sa.average_invoices_per_merchant_standard_deviation # => 1.2
```

### Who are our top performing merchants?

Which merchants are more than two standard deviations *above* the mean?

```ruby
sa.top_merchants_by_invoice_count # => [merchant, merchant, merchant]
```

### Who are our lowest performing merchants?

Which merchants are more than two standard deviations *below* the mean?

```ruby
sa.bottom_merchants_by_invoice_count # => [merchant, merchant, merchant]
```

### Which days of the week see the most sales?

On which days are invoices created at more than one standard deviation *above* the mean?

```ruby
sa.top_days_by_invoice_count # => ["Sunday", "Saturday"]
```

### What percentage of invoices are not shipped?

What percentage of invoices are `shipped` vs `pending` vs `returned`? (takes symbol as argument)

```ruby
sa.invoice_status(:pending) # => 5.25
sa.invoice_status(:shipped) # => 93.75
sa.invoice_status(:returned) # => 1.00
```





# I3: Item Sales

We've got a good foundation, now it's time to actually track the sale of items. There are three new data files to mix into the system, so for this iteration we'll focus primarily on DAL and Relationships with just a bit of Business Intelligence.

## Data Access Layer

### `InvoiceItemRepository`

Invoice items are how invoices are connected to items. A single invoice item connects a single item with a single invoice.

The `InvoiceItemRepository` is responsible for holding and searching our `InvoiceItem`
instances. It offers the following methods:

* `all` - returns an array of all known `InvoiceItem` instances
* `find_by_id` - returns either `nil` or an instance of `InvoiceItem` with a matching ID
* `find_all_by_item_id` - returns either `[]` or one or more matches which have a matching item ID
* `find_all_by_invoice_id` - returns either `[]` or one or more matches which have a matching invoice ID

The data can be found in `data/invoice_items.csv` so the instance is created and used like this:

```ruby
ir = InvoiceItemRepository.new
ir.from_csv("./data/invoice_items.csv")
invoice = ir.find_by_id(6)
# => <invoice_item>
```

### `InvoiceItem`

The invoice item has the following data accessible:

* `id` - returns the integer id
* `item_id` - returns the item id
* `invoice_id` - returns the invoice id
* `quantity` - returns the quantity
* `unit_price` - returns the unit_price
* `created_at` - returns a `Time` instance for the date the invoice item was first created
* `updated_at` - returns a `Time` instance for the date the invoice item was last modified

It also offers the following method:

* `unit_price_to_dollars` - returns the price of the invoice item in dollars formatted as a `Float`

We create an instance like this:

```ruby
ii = InvoiceItem.new({
  :id => 6,
  :item_id => 7,
  :invoice_id => 8,
  :quantity => 1,
  :unit_price => BigDecimal.new(10.99, 4),
  :created_at => Time.now,
  :updated_at => Time.now
})
```

### `TransactionRepository`

Transactions are billing records for an invoice. An invoice can have multiple transactions, but should have at most one that is successful.

The `TransactionRepository` is responsible for holding and searching our `Transaction`
instances. It offers the following methods:

* `all` - returns an array of all known `Transaction` instances
* `find_by_id` - returns either `nil` or an instance of `Transaction` with a matching ID
* `find_all_by_invoice_id` - returns either `[]` or one or more matches which have a matching invoice ID
* `find_all_by_credit_card_number` - returns either `[]` or one or more matches which have a matching credit card number
* `find_all_by_result` - returns either `[]` or one or more matches which have a matching status

The data can be found in `data/transactions.csv` so the instance is created and used like this:

```ruby
tr = TransactionRepository.new
tr.from_csv("./data/transactions.csv")
transaction = tr.find_by_id(6)
# => <transaction>
```

### `Transaction`

The transaction has the following data accessible:

* `id` - returns the integer id
* `invoice_id` - returns the invoice id
* `credit_card_number` - returns the credit card number
* `credit_card_expiration_date` - returns the credit card expiration date
* `result` - the transaction result
* `created_at` - returns a `Time` instance for the date the transaction was first created
* `updated_at` - returns a `Time` instance for the date the transaction was last modified

We create an instance like this:

```ruby
t = Transaction.new({
  :id => 6,
  :invoice_id => 8,
  :credit_card_number => "4242424242424242",
  :credit_card_expiration_date => "0220",
  :result => "success",
  :created_at => Time.now,
  :updated_at => Time.now
})
```

### `CustomerRepository`

Customers represent a person who's made one or more purchases in our system.

The `CustomerRepository` is responsible for holding and searching our `Customers`
instances. It offers the following methods:

* `all` - returns an array of all known `Customers` instances
* `find_by_id` - returns either `nil` or an instance of `Customer` with a matching ID
* `find_all_by_first_name` - returns either `[]` or one or more matches which have a first name matching the substring fragment supplied
* `find_all_by_last_name` - returns either `[]` or one or more matches which have a last name matching the substring fragment supplied

The data can be found in `data/customers.csv` so the instance is created and used like this:

```ruby
cr = CustomerRepository.new
cr.from_csv("./data/customers.csv")
customer = cr.find_by_id(6)
# => <customer>
```

### `Customer`

The customer has the following data accessible:

* `id` - returns the integer id
* `first_name` - returns the first name
* `last_name` - returns the last name
* `created_at` - returns a `Time` instance for the date the customer was first created
* `updated_at` - returns a `Time` instance for the date the customer was last modified

We create an instance like this:

```ruby
c = Customer.new({
  :id => 6,
  :first_name => "Joan",
  :last_name => "Clarke",
  :created_at => Time.now,
  :updated_at => Time.now
})
```

## Relationships

There are many connections to draw between all these objects. Assuming we start with this:

```ruby
se = SalesEngine.from_csv({
  :items => "./data/items.csv",
  :merchants => "./data/merchants.csv",
  :invoices => "./data/invoices.csv",
  :invoice_items => "./data/invoice_items.csv",
  :transactions => "./data/transactions.csv",
  :customers => "./data/customers.csv"
})
```

Then we can find connections from an invoice:

```ruby
invoice = se.invoices.find_by_id(20)
invoice.items # => [item, item, item]
invoice.transactions # => [transaction, transaction]
invoice.customer # => customer
```

Or a transaction:

```ruby
transaction = se.transactions.find_by_id(40)
transaction.invoice # => invoice
```

And if we started with a merchant we could find the customers who've purchased one or more items at their store:

```ruby
merchant = se.merchants.find_by_id(10)
merchant.customers # => [customer, customer, customer]
```

Or from the customer side we could find the merchants they've purchased from:

```ruby
customer = se.customers.find_by_id(30)
customer.merchants # => [merchant, merchant]
```

## Business Intelligence

* `invoice.is_paid_in_full?` returns true if the invoice is paid in full
* `invoice.total` returns the total $ amount of the invoice

**Note:** Failed charges should never be counted in revenue totals or statistics.





# Iteration 4: Merchant Analytics

Our operations team is asking for better data about of our merchants and have asked for the following:

Find out the total revenue for a given date:

```rb
sa = SalesAnalyst.new

sa.total_revenue_by_date(date) #=> $$
```
**Note:** When calculating revenue the ``unit_price`` listed within ``invoice_items`` should be used. The ``invoice_item.unit_price`` represents the final sale price of an item after sales, discounts or other intermediary price changes.

Find the top x performing merchants in terms of revenue:  

```rb
sa = SalesAnalyst.new

sa.top_revenue_earners(x) #=> [merchant, merchant, merchant, merchant, merchant]
```

If no number is given for `top_revenue_earners`, it takes the top 20 merchants by default:

```rb
sa = SalesAnalyst.new

sa.top_revenue_earners #=> [merchant * 20]
```

Which merchants have pending invoices:

```rb
sa = SalesAnalyst.new

sa.merchants_with_pending_invoices #=> [merchant, merchant, merchant]
```

**Note:** an invoice is considered pending if none of its transactions are successful.

Which merchants offer only one item:

```rb
sa = SalesAnalyst.new

sa.merchants_with_only_one_item #=> [merchant, merchant, merchant]
```

And merchants that only sell one item by the month they registered (merchant.created_at):

```rb
sa.merchants_with_only_one_item_registered_in_month("Month name") #=> [merchant, merchant, merchant]
```

Find the total revenue for a single merchant:

```rb
sa = SalesAnalyst.new

sa.revenue_by_merchant(merchant_id) #=> $
```

which item sold most in terms of quantity and revenue:

```rb
sa = SalesAnalyst.new

sa.most_sold_item_for_merchant(merchant_id) #=> [item] (in terms of quantity sold) or, if there is a tie, [item, item, item]

sa.best_item_for_merchant(merchant_id) #=> item (in terms of revenue generated)
```





# Iteration 5: Customer Analytics

Our marketing team is asking for better data about of our customer base to launch a new project and have the following requirements:

Find out whether or not a given invoice is paid in full:   

```rb
# invoice.transactions.map(&:result) #=> ["failed", "success"]  
invoice.is_paid_in_full? #=> true

# invoice.transactions.map(&:result) #=> ["failed", "failed"]  
invoice.is_paid_in_full? #=> false
```

**Note:** Returns true if at least one of the associated transactions' result is "success".  

Find the x customers that spent the most $:

```rb
sa = SalesAnalyst.new

sa.top_buyers(x) #=> [customer, customer, customer, customer, customer]
```

If no number is given for `top_buyers`, it takes the top 20 customers by default

```rb
sa = SalesAnalyst.new

sa.top_buyers #=> [customer * 20]
```

Be able to find which merchant the customers bought the most items from:

```rb
sa = SalesAnalyst.new

sa.top_merchant_for_customer(customer_id) #=> merchant
```

Find which customers only had one transaction:

```rb
sa = SalesAnalyst.new

sa.one_time_buyers #=> [customer, customer, customer]
```

Find which item most `one_time_buyers` bought:

```rb
sa = SalesAnalyst.new

sa.one_time_buyers_item #=> [item, item]
```

Find which items a given customer bought in given year (by the `created_at` on the related invoice):

```rb
sa = SalesAnalyst.new

sa.items_bought_in_year(customer_id, year) #=> [item]
```

Return all items that were purchased most if there are several with the same quantity:

```rb
sa = SalesAnalyst.new

sa.most_recently_bought_items(customer_id) #=> [item, item, item]
```

Find customers with unpaid invoices:

```rb
sa = SalesAnalyst.new

sa.customers_with_unpaid_invoices #=> [customer, customer, customer]
```

**Note:** invoices are unpaid if one or more of the invoices are not paid in full (see method `invoice#is_paid_in_full?`).

Find the best invoice, the invoice with the highest dollar amount:

```rb
sa.best_invoice_by_revenue #=> invoice
```

```rb
sa.best_invoice_by_quantity #=> invoice
```