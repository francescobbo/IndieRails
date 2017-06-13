class PostsController < ApplicationController
  def index
  end

  def show
    post = Post.find(params[:id])

    set_meta_tags({
      title: post.title.presence || "Status Update #{l(post.created_at, format: :short)}"
    })

    if post.deleted?
      render :tombstone, status: :gone
    else
      render locals: {
        post: post
      }
    end
  end
end
