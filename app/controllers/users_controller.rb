class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:show] # app_controller ログイン要求処理 => showはログインしていないユーザーには見せたくない。
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

## 7.1 ~ 7.5 ユーザー登録機能　2017/12/18 21:00　##