class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items

  enum payment: { credit_card: 0, cod: 1}
  enum order_status: { waiting_for_payment: 0, payment_confirmed: 1, in_production: 2, preparing_to_ship: 3, shipped: 4 }

  def self.order_statuses_i18n
     order_statuses.keys.map do |status|
       [I18n.t("enums.order.order_status.#{status}"), status]
     end.to_h
  end
end
