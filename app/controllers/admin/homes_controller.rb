class Admin::HomesController < ApplicationController
  def top
    @genres = Genre.all
    @items = Item.where(is_active: true)

    if params[:genre_id].present?
      @items = @items.where(genre_id: params[:genre_id])
    end

    @items = @items.page(params[:page])
  end
end
