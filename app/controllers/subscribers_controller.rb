class SubscribersController < ApplicationController
  def create
    subscriber = Subscriber.new(name: params[:name], email: params[:email])

    if subscriber.save
      cookies.permanent[:subscribed] = true
      render json: { ok: 1 }
    else
      if subscriber.errors[:email][0] && subscriber.errors[:email][0][:error] == :taken
        # True hero! Tries to subscribe twice
        cookies.permanent[:subscribed] = true
        render json: { ok: 1 }
      else
        head :unprocessable_entity
      end
    end
  end
end
