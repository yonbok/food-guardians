class Address < ApplicationRecord
   belongs_to :customer

   def address_display
     '〒' + postcode + ' ' + address + ' ' + name
   end

   validates :postcode, presence:true,length: { is: 7 }
   validates :address, presence:true
   validates :name, presence:true
end
