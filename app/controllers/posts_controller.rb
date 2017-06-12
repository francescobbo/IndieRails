class PostsController < ApplicationController
  def index
  end

  def show
    post = Post.find(params[:id])

    if post.deleted?
      render :tombstone, status: :gone
    else
      render locals: {
        post: post
      }
    end
  end
end
