module Admin
  class PostsController < AdminController
    def index
    end

    def new
      render locals: {
        post: Post.new
      }
    end

    def show
      post = Post.find(params[:id])

      render locals: {
        post: post
      }
    end

    def create
      post = Post.new(params.require(:post).permit(:kind, :title, :body))

      if post.save
        redirect_to [:admin, post]
      else
        render :new, locals: {
          post: post
        }
      end
    end
  end
end
