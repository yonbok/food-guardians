class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items
  has_many :order_details

  enum payment: { credit_card: 0, cod: 1}

  def total_price
    order_details.sum{ |detail| detail.buy_price } + shipping_fee
  end

end
