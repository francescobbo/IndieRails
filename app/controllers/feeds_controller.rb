class FeedsController < ApplicationController
  def show
    render locals: {
      posts: Post.published
    }
  end
end
