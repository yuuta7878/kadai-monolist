class ItemsController < ApplicationController
  before_action :require_user_logged_in
  
  def new
    # @itemsをカラの配列として初期化
    # カラの理由 => 検索ワードが入力されたときだけだから
    # 初期化理由 => View 側で @items にアクセスしたときに nil となってしまい、エラーが発生する
    @items = []
    
    # フォームから送信される検索ワードを取得
    # Viewのtext_field_tag :keyword という inputを受け取る
    @keyword = params[:keyword]
    # 検索ワード(@keyword)が与えられているとif文の中の処理が実行され、楽天APIを使用して検索を実行します。検索時のオプションは、
    # 検索ワードを設定し、画像があるもののみに絞り込み、20件検索するオプションです。
    # この検索結果は results に代入されます。
    if @keyword
      results = RakutenWebService::Ichiba::Item.search({
        keyword: @keyword,
        imageFlag: 1,
        hits: 20,
      })

      results.each do |result|
        # 扱い易いように Item としてインスタンスを作成する（保存はしない）
        item = Item.find_or_initialize_by(read(result))
        @items << item
      end
    end
  end
  
  def show
    @item = Item.find(params[:id])
    @want_users = @item.want_users
    @have_users = @item.have_users
  end
end