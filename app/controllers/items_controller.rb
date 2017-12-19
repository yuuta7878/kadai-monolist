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
        item = Item.new(read(result))
        @items << item
      end
    end
  end
  
  private
  
  def read(result)
    code = result['itemsCode']
    name = result['itemName']
    url = result['itemUrl']
    # 画像 URL 末尾に含まれる ?_ex=128x128を削除している
    # 楽天APIの仕様上、サイズ指定無しの画像を取得できないので、
    # 無理矢理ですが、元画像をこのようにして取得している。
    image_url = result['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128', '') 
    
    return {
      code: code,
      name: name,
      url: url,
      image_url: image_url,
    }
  end
end
  
  