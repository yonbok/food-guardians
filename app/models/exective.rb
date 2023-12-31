class Exective < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :items
  validates :name, presence:true
  validates :kana_name, presence:true
  validates :phone_number, presence:true
  validates :post_code, length: { is: 7 }
  validates :address, presence:true
  validates :email, presence:true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |exective|
      exective.password = SecureRandom.urlsafe_base64
      exective.name = "経営者ゲスト"
      exective.kana_name = "ケイエイシャゲスト"
      exective.phone_number = "10101010101"
      exective.post_code = "1010101"
      exective.address = "東京都江東区"
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
      # 例えば name を入力必須としているならば， user.name = "ゲスト" なども必要
    end
  end

  # has_one_attached :photo_image
  # def get_photo_image(width, height)
  #   unless photo_image.attached?
  #     file_path = Rails.root.join('app/assets/images/no_image.jpg')
  #     photo_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
  #   end
  #   photo_image.variant(resize_to_limit: [width, height]).processed
  # end

  def active_for_authentication?
    super && (is_deleted == false)
  end
end
