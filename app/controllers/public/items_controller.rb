class Public::ItemsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_item, only: %i[show edit update]

  def index
    @items = Item.all.page(params[:page])
    @genres = Genre.all
  end

  def show
   @item = Item.find(params[:id])
   @cart_item = CartItem.new
   @genres = Genre.all
  end


  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:items).permit(:image,:name,:description,:price, :genre_id)
  end
end
