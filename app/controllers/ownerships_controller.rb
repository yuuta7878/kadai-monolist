class OwnershipsController < ApplicationController
# wantの処理
  def create
    # Item の Want ボタンが押されたときにこのアクションに行き着きます。また、このタイミングで Item を保存します。
    # Item.find_by して見つかればテーブルに保存されていたインスタンスを返し、見つからなければ Item.new して新規作成する便利メソッド
    @item = Item.find_or_initialize_by(code: params[:item_code])
    # 取得したインスタンス @item が、既に保存されているかどうかを判断する
    # unless @item.persisted? は、@item がテーブルに保存されていなければブロック内の処理を実行します。
    unless @item.persisted?
      # @item が保存されていない場合、先に @itemを保存する処理が実行される。
      results = RakutenWebService::Ichiba::Item.search(itemCode: @item.code)

      @item = Item.new(read(results.first))
      @item.save
    end

    # Want 関係として保存 => Haveボタンとの処理を区別するための記述
    if params[:type] == 'Want'
      current_user.want(@item)
      flash[:success] = '商品を Want しました。'
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @item = Item.find(params[:item_id])

    if params[:type] == 'Want'
      current_user.unwant(@item) 
      flash[:success] = '商品の Want を解除しました。'
    end

    redirect_back(fallback_location: root_path)
  end
end