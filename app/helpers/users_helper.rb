module UsersHelper
  def gravatar_url(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=mm" 
    # &d=mm => Gravatarで自分のメールアドレスに対応する画像が登録されていない場合に使用されるデフォルトイメージを変更している。
  end
end
