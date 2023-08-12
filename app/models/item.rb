class Item < ApplicationRecord
  has_many :cart_items
  belongs_to :genre, optional: true
  has_many :order_datails
  validates :price, presence: true

 def price_including_tax
  (price * 1.1).floor  # 税率を10%として計算して切り捨て
 end

  has_one_attached :item_image
  def get_item_image(width, height)
    unless item_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      item_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
    end
    item_image.variant(resize_to_limit: [width, height]).processed
  end

end
