class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items
  has_many :order_details

  #enum payment_method: { credit_card: 0, cod: 1}
  enum payment: { credit_card: 0, cod: 1}
  enum order_status: { waiting_for_payment: 0, payment_confirmed: 1, in_production: 2, preparing_to_ship: 3, shipped: 4 }

  def total_price
    order_details.sum{ |detail| detail.buy_price } + shipping_fee
  end

  def self.order_statuses_i18n
     order_statuses.keys.map do |status|
       [I18n.t("enums.order.order_status.#{status}"), status]
     end.to_h
  end
end
