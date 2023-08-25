class Admin::ExectivesController < ApplicationController
  before_action :authenticate_admin!
  def index
    @exectives = Exective.all#.page(params[:page]).per(10)
  end

  def show
     @exective = Exective.find(params[:id])
  end

  def edit
    @exective = Exective.find(params[:id])
  end

  def update
    @exective = Exective.find(params[:id])
    if @exective.update(exective_params)
      redirect_to admin_exective_path(@exective), notice: "会員情報を更新しました。"
    else
      render :edit
    end
  end

  private

  def exective_params
    params.require(:exective).permit(:name, :kana_name, :email, :post_code, :address, :phone_number, :is_deleted)
  end
end
