module Admin
  class SessionsController < ApplicationController
    def new
    end

    def create
      if params[:password] == Rails.application.secrets.admin_password
        cookies.signed.encrypted[:admin] = true
        redirect_to admin_posts_path
      else
        flash.now[:signin] = "Invalid password"
        render :new
      end
    end

    def delete
      cookies.delete(:admin)
      redirect_to root_path
    end
  end
end
