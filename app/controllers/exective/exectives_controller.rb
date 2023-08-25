class Exective::ExectivesController < ApplicationController

  def show
    @exective = current_exective
    @exectives = Exective.all
   #@orders = Order.all
  end


  def withdraw
    @exective = Exective.find(current_exective.id)
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @exective.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end
end
