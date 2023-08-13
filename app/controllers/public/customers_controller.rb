class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!


  def withdraw
    @customer = Customer.find(current_customer.id)
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @customer.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end


  private

  def customer_params
    params.require(:customer).permit(:name, :kana_name, :postcode, :address, :email, :phone_number)
  end
end
