class Public::OrdersController < ApplicationController
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
      @order.order_status = 0
      if @order.save
        cart_items.each do |cart|
      # order_detail にも一緒にデータを保存する必要があるのでここで保存
          order_detail = OrderDetail.new
          order_detail.item_id = cart.item_id
          order_detail.order_id = @order.id
          order_detail.quantity = cart.quantity
          order_detail.buy_price = cart.subtotal
      # 購入が完了したらカート情報は削除するのでここに保存
          #order_detail.buy_price = cart.item.buy_price
      # カート情報を削除するので item との紐付けが切れる前に保存
          order_detail.save
        end
        flash[:notice] = "ご注文が確定しました。"
        redirect_to complete_cart_item_orders_path
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
        @order.customer_id = current_customer.id
      elsif params[:order][:address_number] == "2"
      # view で定義している address_number が"2"だったときにこの処理を実行
        if Address.exists?(name: params[:order][:registered])
      # registered は viwe で定義している
          @order.name = Address.find(params[:order][:registered]).name
          @order.address = Address.find(params[:order][:registered]).address
          @order.postcode = Address.find(params[:order][:registered]).postcode
          @order.customer_id = Address.find(params[:order][:registered]).customer_id
        else
          render :new
      # 既存のデータを使っているためあり得ないとは思うが、万が一データが足りない場合は new を renderする
        end
      elsif params[:order][:address_number] == "3"
      # view で定義している address_number が"3"だったときにこの処理を実行
        address_new = current_customer.addresses.new(address_params)
        if address_new.save
        else
          render :new
      # ここに渡ってくるデータはユーザーで新規追加してもらうので、入力不足の場合は new に戻す
        end
      else
        redirect_to  cart_item_addresses_path # 万が一当てはまらないデータが渡ってきた場合の処理
      end
      @cart_items = current_customer.cart_items.all # カートアイテムの情報をユーザーに確認してもらうために使用
      @total = 0
      @shiptotal = 0
    end

    def complete
    end

     def index
       @orders = current_customer.orders
     end

    def show
      @order = Order.find(params[:id])
      @order_details = OrderDetail.where(order_id: params[:id])
    end

    private

    def order_params
      params.require(:order).permit(:name, :address, :customer_id, :payment, :postcode, :order_status, :shipping_fee)
    end

    def order_detail_params
      params.require(:order_detail).permit(:order_id, :item_id, :quantity, :buy_price, :production_status)
    end

    def address_params
      params.require(:order).permit(:name, :address, :customer_id, :postcode)
    end
end
