class PostsController < ApplicationController
  def index
    set_meta_tags({
      title: "Home Page",
      description: 'My personal home page'
    })
  end

  def show
    post = Post.find(params[:id])

    set_meta_tags({
      title: post.title.presence || "Status Update #{l(post.created_at, format: :short)}",
      description: truncate(post.content, separator: ' ', omission: ' ', length: 150)
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
