class PostsController < ApplicationController
  def index
    set_meta_tags({
      title: "Home Page",
      description: 'My personal home page'
    })
  end

  def show
    post = Post.find(params[:id])

    if post.published?
      set_meta_tags({
        title: post.title.presence || "Status Update #{l(post.created_at, format: :short)}",
        description: post.meta_description
      })

      render locals: {
        post: post
      }
    elsif post.deleted?
      set_meta_tags({
        title: "This post has been deleted",
        description: "This post has been deleted"
      })

      render :tombstone, status: :gone
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
