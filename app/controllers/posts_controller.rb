class PostsController < ApplicationController
  def index
    set_meta_tags(title: 'Home Page',
                  description: 'My ramblings about AWS, Ruby and Tech in general. I\'m getting AWS certified!')

    articles = Article.published.order(published_at: :desc)
    if I18n.locale == :it
      articles = articles.where.not(title_it: nil)
    else
      articles = articles.where.not(title: nil)
    end

    render locals: {
      articles: articles
    }
  end

  def show
    post = Post.find(params[:id])

    if post.published?
      set_meta_tags(title: post.title.presence || "Status Update #{l(post.created_at, format: :short)}",
                    description: post.meta_description)

      if post.article?
        set_meta_tags(social_metas(post))
      end

      render locals: {
        post: post
      }
    elsif post.deleted?
      set_meta_tags(title: 'This post has been deleted',
                    description: 'This post has been deleted')

      render :tombstone, status: :gone
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  private

  def social_metas(post)
    {
      twitter: {
        card: 'summary',
        site: 'frboffa',
        title: post.title,
        description: post.meta_description,
        image: post.main_medium&.file&.url(:large)
      },
      fb: {
        app_id: '1926390900931123'
      },
      og: {
        title: post.title,
        description: post.meta_description,
        image: post.main_medium&.file&.url(:large),
        url: article_url(post),
        site_name: 'Francesco Boffa',
        locale: 'en_US',
        type: 'article'
      },
      article: {
        section: 'Technology',
        published_time: post.published_at.iso8601,
        modified_time: post.updated_at.iso8601
      }
    }
  end
end
