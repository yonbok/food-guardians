class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!
    def new
      @order = Order.new
      @orders = current_customer.orders
      @addresses = current_customer.addresses.all
      @cart_items = CartItem.all
    end

    # 購入を確定
    def create
      cart_items = current_customer.cart_items.all
      # ログインユーザーのカートアイテムをすべて取り出して cart_items に入れる
      @order = current_customer.orders.new(order_params)
      if @order.save
        cart_items.each do |cart|
      # order_detail にも一緒にデータを保存する必要があるのでここで保存
          order_detail = OrderDetail.new
          order_detail.item_id = cart.item_id
          order_detail.order_id = @order.id
          order_detail.quantity = cart.quantity
          order_detail.buy_price = cart.subtotal
      # カート情報を削除するので item との紐付けが切れる前に保存
          order_detail.save
        end
        flash[:notice] = "ご注文が確定しました。"
        redirect_to complete_orders_path
        cart_items.destroy_all
      # ユーザーに関連するカートのデータ(購入したデータ)をすべて削除(カートを空にする)
      else
        @order = Order.new(order_params)
        render :new
      end
    end


    # new 画面から渡ってきたデータをユーザーに確認してもらう
    def confirm
      @order = Order.new(order_params)
      if params[:order][:address_number] == "1"
      # view で定義している address_number が"1"だったときにこの処理を実行
      # form_with で @order で送っているので、order に紐付いた address_number となる
        @order.name = current_customer.name
        @order.address = current_customer.address
        @order.postcode = current_customer.post_code
      elsif params[:order][:address_number] == "2"
      # view で定義している address_number が"2"だったときにこの処理を実行
        address_new = current_customer.addresses.new(address_params)
        if address_new.save
        else
          render :new
      # ここに渡ってくるデータはユーザーで新規追加してもらうので、入力不足の場合は new に戻す
        end
      else
        render :new # 万が一当てはまらないデータが渡ってきた場合の処理
      end
      @cart_items = current_customer.cart_items.all # カートアイテムの情報をユーザーに確認してもらうために使用
      @total = 0
      @shiptotal = 0
    end

    def complete
    end

     def index
       @orders = current_customer.orders
       @order_details = OrderDetail.where(order_id: @orders.ids)
       @cart_item = CartItem.all
     end

    def show
      @order = Order.find(params[:id])
      @order_details = OrderDetail.where(order_id: params[:id])
    end

    private

    def order_params
      params.require(:order).permit(:name, :address, :customer_id, :payment, :postcode, :shipping_fee)
    end

    def order_detail_params
      params.require(:order_detail).permit(:order_id, :cart_item_id, :quantity, :buy_price, :production_status)
    end

    def address_params
      params.require(:order).permit(:name, :address, :customer_id, :postcode)
    end
end
