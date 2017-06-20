module Admin
  class ArticlesController < AdminController
    def index
      render locals: {
        articles: Post.article
      }
    end

    def new
      article = Post.new
      article.build_main_medium

      render locals: {
        article: article
      }
    end

    def create
      article = Post.new(article_params)
      article.kind = :article

      if article.save
        redirect_to admin_article_path(article)
      else
        render :new, locals: {
          article: article
        }
      end
    end

    def show
      article = Post.article.find(params[:id])

      render locals: {
        article: article
      }
    end

    def edit
      article = Post.article.find(params[:id])

      render locals: {
        article: article
      }
    end

    def update
      article = Post.article.find(params[:id])

      if article.update(article_params)
        redirect_to admin_article_path(article)
      else
        render :edit, locals: {
          article: article
        }
      end
    end

    def destroy
      article = Post.article.find(params[:id])
      article.deleted = true
      article.save

      redirect_to admin_articles_path
    end

    def undestroy
      article = Post.article.find(params[:id])
      article.deleted = false
      article.save

      redirect_to admin_article_path(article)
    end

    private

    def article_params
      params.require(:post).permit(:title, :body, :draft, main_medium_attributes: [:file])
    end
  end
end
