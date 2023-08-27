class Public::AddressesController < ApplicationController
   before_action :authenticate_customer!


  def index
    @addresses = current_customer.addresses
    @cart_item = CartItem(@cart_item)
    @address = Address.new
  end

  def edit
    @address = Address.find(params[:id])
  end

  def create
    @address = Address.new(address_params)
    @address.customer_id = current_customer.id
    if  @address.save
      flash[:notice] = "配送先の登録に成功しました"
      redirect_to cart_item_addresses_path
    else
      @addresses = current_customer.addresses
      redirect_to cart_item_addresses_path
    end
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      flash[:notice] = "配送先の更新に成功しました"
      redirect_to cart_item_addresses_path
    else
      redirect_to edit_cart_item_address_path(@address)
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    @address = current_customer.addresses
     flash[:notice] = "登録内容は正常に削除されました"
     redirect_to cart_item_addres_path
  end



  private

def address_params
  params.require(:address).permit(:postcode, :name, :address).merge(customer_id: current_customer.id)
end

end
