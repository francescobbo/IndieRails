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
        seo = Seo::ArticleDecorator.new(post)
        set_meta_tags(seo.meta)
        add_jsonld(seo.jsonld)
      end

      set_meta_tags(language_metas(post))

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

  def language_metas(post)
    alternate = {}
    alternate['it'] = post_url(:it, post.slug_it) if post.slug_it
    alternate['en'] = post_url(nil, post.slug_en) if post.slug_en

    { alternate: alternate }
  end
end
