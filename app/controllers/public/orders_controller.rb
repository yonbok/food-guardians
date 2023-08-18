class Public::OrdersController < ApplicationController
    def new
      @order = Order.new
    end

    # 購入を確定
    def create
      cart_items = current_customer.cart_items.all
      # ログインユーザーのカートアイテムをすべて取り出して cart_items に入れる
      @order = current_customer.orders.new(order_params)
      # 渡ってきた値を @order に入れます
      if @order.save
        cart_items.each do |cart|
      # order_detail にも一緒にデータを保存する必要があるのでここで保存
          order_detail = OrderDetail.new
          order_detail.item_id = cart.item_id
          order_detail.order_id = @order.id
          order_detail.order_quantity = cart.quantity
      # 購入が完了したらカート情報は削除するのでここに保存
          order_item.order_price = cart.item.price
      # カート情報を削除するので item との紐付けが切れる前に保存
          order_item.save
        end
        redirect_to 遷移したいページのパス
        cart_items.destroy_all
      # ユーザーに関連するカートのデータ(購入したデータ)をすべて削除(カートを空にする)
      else
        @order = Order.new(order_params)
        render :new
      end
    end


    # new 画面から渡ってきたデータをユーザーに確認してもらう
    def check
      @order = Order.new(order_params)
      # new 画面から渡ってきたデータを @order に入れる
      if params[:order][:address_number] == "1"
      # view で定義している address_number が"1"だったときにこの処理を実行
      # form_with で @order で送っているので、order に紐付いた address_number となる
        @order.name = current_customer.name # @order の各カラムに必要なものを入れる
        @order.address = current_customer.customer_address
      elsif params[:order][:address_number] == "2"
    # view で定義している address_number が"2"だったときにこの処理を実行します
        if Address.exists?(name: params[:order][:registered])
    # registered は viwe で定義しています
          @order.name = Address.find(params[:order][:registered]).name
          @order.address = Address.find(params[:order][:registered]).address
        else
          render :new
    # 既存のデータを使っていますのでありえないですが、万が一データが足りない場合は new を render します
        end
      elsif params[:order][:address_number] == "3"
    # view で定義している address_number が"3"だったときにこの処理を実行します
        address_new = current_customer.addresses.new(address_params)
        if address_new.save # 確定前(確認画面)で save してしまうことになりますが、私の知識の限界でした
        else
          render :new
    # ここに渡ってくるデータはユーザーで新規追加してもらうので、入力不足の場合は new に戻します
        end
      else
        redirect_to 遷移したいページ # ありえないですが、万が一当てはまらないデータが渡ってきた場合の処理です
      end
      @cart_items = current_customer.cart_items.all # カートアイテムの情報をユーザーに確認してもらうために使用します
      @total = @cart_items.inject(0) { |sum, item| sum + item.sum_price }
    # 合計金額を出す処理です sum_price はモデルで定義したメソッドです
    end

    private

    def order_params
      params.require(:order).permit(:name, :address, :customer_id, :payment, :postcode, :order_status, :shipping_fee)
    end

    def address_params
      params.require(:address).permit(:name, :address, :customer_id, :postcode)
    end
  end
