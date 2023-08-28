class Exective::ExectivesController < ApplicationController

  def show
    @exective = current_exective
    @exectives = Exective.all
  end

  def edit
    @exective = current_exective
  end

  def update
    @exective = current_exective
    if @exective.update(exective_params)
      redirect_to exective_exective_path(@exective), notice: "登録情報が更新されました。"
    else
      render :edit
    end
  end

  def withdraw
  end

  def withdraw_update
    current_exective.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end

   private

  def exective_params
    params.require(:exective).permit(:name, :kana_name, :postcode, :address, :email, :phone_number)
  end

  #def withdraw
    #@exective = Exective.find(current_exective.id)
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    #@exective.update(is_deleted: true)
    #reset_session
    #flash[:notice] = "退会処理を実行いたしました"
    #redirect_to root_path
  #end
end
