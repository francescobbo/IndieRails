module Admin
  class AdminController < ApplicationController
    before_action :ensure_admin
    layout 'admin'

    private

    def ensure_admin
      redirect_to admin_signin_path unless cookies.signed.encrypted[:admin] == true
    end
  end
end
