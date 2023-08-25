class Admin::HomesController < ApplicationController
  def top
    @items = Item.all
  end
end
