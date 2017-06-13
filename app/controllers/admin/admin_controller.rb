module Admin
  class AdminController < ApplicationController
    before_action :set_title, :ensure_admin
    layout 'admin'

    private

    def set_title
      set_meta_tags(title: 'Admin')
    end

    def ensure_admin
      redirect_to admin_signin_path unless cookies.signed.encrypted[:admin] == true
    end
  end
end
