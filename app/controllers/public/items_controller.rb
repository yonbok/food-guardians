class Public::ItemsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_item, only: %i[show edit update]

  def index
    @genres = Genre.all
    if params[:genre_id].present?
      @items = Item.where(genre_id: params[:genre_id], is_active: true)
    else
      @items = Item.where(is_active: true)
    end

    if params[:search].present?
      @items = @items.where('name LIKE ?', "%#{params[:search]}%")
    end
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
