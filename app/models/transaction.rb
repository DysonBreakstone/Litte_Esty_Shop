class Transaction < ApplicationRecord
  belongs_to :invoice
  has_one :invoice_item, through: :invoice 
  has_one :customer, through: :invoice
  
  
  enum result: ["failed", "success"]
end