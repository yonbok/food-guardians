class Admin::HomesController < ApplicationController
  def top
    @items = Item.all
    @genres = Genre.all
  end
end
