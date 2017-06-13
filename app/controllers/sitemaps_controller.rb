class SitemapsController < ApplicationController
  def show
    render locals: {
      posts: Post.published.order(created_at: :desc)
    }
  end
end
