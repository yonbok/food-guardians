class CartItem < ApplicationRecord
  belongs_to :item
  belongs_to :customer
  belongs_to :order, optional: true

  def subtotal
    item.price_including_tax * quantity
  end
end
