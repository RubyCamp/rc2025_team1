class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # ユーザー登録が成功したら、すぐにログインさせる
      log_in @user

      flash[:notice] = "ユーザー登録が完了しました！"
      redirect_to "/"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # log_outヘルパーメソッドを呼び出して、セッションをクリアする
    log_out if logged_in?

    # ログアウト後のリダイレクト先を指定
    redirect_to root_url, notice: "ログアウトしました。"
  end

  def profile
    @current_user = current_user
  end

  def edit
    @user = current_user
  end

  def change
    @user = current_user

    @user.name = user_params[:name]
    @user.save(validate: false)

    redirect_to profile_path(@user)
  end

  def login
  end

  def check
    user = User.find_by(mail: params[:session][:mail].downcase)

    if user && user.authenticate(params[:session][:password])
      # ログイン成功
      log_in user
      redirect_to "/", notice: "ログインしました。"
    else
      # ログイン失敗
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません。"
      render "login", status: :unprocessable_entity
    end
  end

  private

  # Strong Parametersを定義するプライベートメソッド
  def user_params
    # :userキーを必須とし、その中から :email, :password のみを許可する
    params.require(:session).permit(:name, :mail, :password, :password_confirmation)
  end
end
