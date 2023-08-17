# frozen_string_literal: true

class Exective::SessionsController < Devise::SessionsController
  #before_action :reject_exective, only: [:create]

  def new
    @exective = Exective.new
  end
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def guest_sign_in
    exective = Exective.guest
    sign_in exective
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end


  protected

  def reject_exective
    @exective = Exective.find_by(email: params[:exective][:email])
    if @exective
      if @exective.valid_password?(params[:exective][:password]) && (@exective.is_deleted == true)
        flash[:notice] = "退会済みです。再度ご登録をしてご利用ください"
        redirect_to new_exective_registration_path
      else
        flash[:notice] = "項目を入力してください"
      end
    else
      flash[:notice] = "該当するユーザーが見つかりません"
    end
  end

end
