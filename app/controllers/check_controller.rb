class CheckController < ApplicationController
  def inquiry
    @inquiries = Inquiry.all
  end
end