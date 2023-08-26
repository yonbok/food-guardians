class Admin::ItemsController < ApplicationController

  def show
    @item = Item.find(params[:id])
    @genres = Genre.all
  end

end
