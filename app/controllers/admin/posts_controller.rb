module Admin
  class PostsController < AdminController
    def index
      render locals: {
        posts: Post.all
      }
    end

    def new
      post = Post.new
      post.build_main_medium

      render locals: {
        post: post
      }
    end

    def create
      post = Post.new(post_params)

      if post.save
        redirect_to [:admin, post]
      else
        render :new, locals: {
          post: post
        }
      end
    end

    def show
      post = Post.find(params[:id])

      render locals: {
        post: post
      }
    end

    def edit
      post = Post.find(params[:id])

      render locals: {
        post: post
      }
    end

    def update
      post = Post.find(params[:id])

      if post.update(post_params)
        redirect_to [:admin, post]
      else
        render :edit, locals: {
          post: post
        }
      end
    end

    def destroy
      post = Post.find(params[:id])
      post.deleted = true
      post.save

      redirect_to %i[admin posts]
    end

    def undestroy
      post = Post.find(params[:id])
      post.deleted = false
      post.save

      redirect_to [:admin, post]
    end

    private

    def post_params
      params.require(:post).permit(:kind, :title, :body, :draft, main_medium_attributes: [:file])
    end
  end
end
