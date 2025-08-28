class ReviewsController < ApplicationController
  before_action :set_onsen,
  def new
    @review = @onsen.reviews.build
  end

  def create
    @user = current_user
    # user_idをparamsにマージする
    review_attributes = review_params.merge(userid: @user.id)

    # buildメソッドに1つのハッシュを渡す
    @review = @onsen.reviews.build(review_attributes)
    if @review.save
      redirect_to onsen_path(@onsen), notice: t("flash.review_created")
    else
      @reviews = @onsen.reviews.order(created_at: :desc)
      render "onsens/show", status: :unprocessable_entity
    end
  end

  private

    def set_onsen
      @onsen = Onsen.find(params[:onsen_id])
    end

    def review_params
      params.require(:review).permit(:rating, :comment, images: [])
    end
end
