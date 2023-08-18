class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @cart_items = current_customer.cart_items.all
    @toal = 0
  end

  def update
    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to cart_items_path, notice: "数量の変更を保存しました"
    else
      redirect_to request.referer, alert: "正しい数字を入力してください"
    end
    if @cart_item.quantity == 0
      @cart_item.destroy
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_items_path, notice: "商品の削除に成功しました"
  end

  def destroy_all
      cart_items = CartItem.all
      cart_items.destroy_all
      redirect_to cart_items_path, notice: "カート内を空にしました"
  end

  def create
    @cart_item = current_customer.cart_items.new(cart_item_params)

    if current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id]).present?
        cart_item = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
        cart_item.quantity += params[:cart_item][:quantity].to_i
        cart_item.save
        redirect_to cart_items_path

    elsif @cart_item.save
          @cart_items = current_customer.cart_items.all
          render 'index'
    else
        render 'index'
    end
  end

  def cart_item_params
    params.require(:cart_item).permit(:item_id, :quantity, :customer_id)
  end
end
