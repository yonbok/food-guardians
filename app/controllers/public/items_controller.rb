class Public::ItemsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_item, only: %i[show edit update]

  def index
    @genres = Genre.all
    @items = Item.where(is_active: true)

    if params[:genre_id].present?
      @items = @items.where(genre_id: params[:genre_id])
    end

    @items = @items.page(params[:page])
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
