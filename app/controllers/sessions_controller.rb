class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    puts user_params
    user = User.new(user_params)

    user.save

    redirect_to("/")
  end

  def destroy
  end

  private

  # Strong Parametersを定義するプライベートメソッド
  def user_params
    # :userキーを必須とし、その中から :email, :password のみを許可する
    params.require(:session).permit(:mail, :password)
  end
end
