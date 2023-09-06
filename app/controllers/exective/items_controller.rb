class Exective::ItemsController < ApplicationController
  before_action :authenticate_exective!
  before_action :set_item, only: %i[show edit update]

  def index
    @items = Item.page(params[:page])
    @genres = Genre.all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    #@item.genre_id = 1 #仮実装
    if @item.save
      redirect_to exective_item_path(@item)
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to exective_item_path(@item), notice: '商品が更新されました'
    else
      render :edit
    end
  end


  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :price, :item_image, :genre_id, :is_active)
  end
end
