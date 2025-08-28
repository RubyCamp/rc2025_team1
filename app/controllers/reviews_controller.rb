class ReviewsController < ApplicationController
  before_action :set_onsen, @user = current_user
  def new
    @review = @onsen.reviews.build
  end

  def create
    @review = @onsen.reviews.build(review_params, userid: @user.id)
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
