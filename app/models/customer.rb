class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

   has_many :addresses
   has_many :orders
   has_many :cart_items, dependent: :destroy
   validates :name, presence:true
   validates :kana_name, presence:true
   validates :phone_number, presence:true
   validates :post_code, length: { is: 7 }
   validates :address, presence:true
   validates :email, presence:true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

   def self.guest
    find_or_create_by!(email: 'guest@example.com') do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.name = "消費者ゲスト"
      customer.kana_name = "ショウヒシャゲスト"
      customer.phone_number = "10101010101"
      customer.post_code = "9090909"
      customer.address = "東京都江東区"
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
      # 例えば name を入力必須としているならば， user.name = "ゲスト" なども必要
    end
   end

   # ログイン時に退会済みのユーザーが同じアカウントでログイン出来ないようにする
   def active_for_authentication?
    super && (is_deleted == false)
   end
end
