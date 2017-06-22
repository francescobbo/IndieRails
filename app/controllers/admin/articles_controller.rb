module Admin
  class ArticlesController < AdminController
    def index
      render locals: {
        articles: Article.all
      }
    end

    def new
      article = Article.new
      article.build_main_medium

      render locals: {
        article: article
      }
    end

    def create
      art_params = article_params
      art_params.delete(:main_medium_attributes) if art_params[:main_medium_attributes][:file].nil?
      art_params.delete(:main_medium_attributes) if art_params[:main_medium_id]

      article = Article.new(art_params)

      if article.save
        redirect_to admin_article_path(article)
      else
        render :new, locals: {
          article: article
        }
      end
    end

    def show
      article = Article.find(params[:id])

      render locals: {
        article: article
      }
    end

    def edit
      article = Article.find(params[:id])

      render locals: {
        article: article
      }
    end

    def update
      art_params = article_params
      if art_params[:main_medium_id] ||
         (art_params[:main_medium_attributes] && art_params[:main_medium_attributes][:file].nil?)
          art_params.delete('main_medium_attributes')
      end

      article = Article.find(params[:id])

      if article.update(art_params)
        redirect_to admin_article_path(article)
      else
        render :edit, locals: {
          article: article
        }
      end
    end

    def destroy
      article = Article.find(params[:id])
      article.deleted = true
      article.save

      redirect_to admin_articles_path
    end

    def undestroy
      article = Article.find(params[:id])
      article.deleted = false
      article.save

      redirect_to admin_article_path(article)
    end

    private

    def article_params
      params.require(:article).permit(:title, :body, :draft, :main_medium_id, main_medium_attributes: [:file])
    end
  end
end
