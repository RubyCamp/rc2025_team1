class InquiryController < ApplicationController
  def inquiry
    if request.post?
      @inquiry = Inquiry.new(inquiry_params)
      if @inquiry.save
        redirect_to root_path, notice: 'お問い合わせありがとうございます。'
      else
        render :inquiry
      end
    else
      @inquiry = Inquiry.new
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :content)
  end
end
