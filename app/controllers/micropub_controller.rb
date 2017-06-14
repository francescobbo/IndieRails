class MicropubController < ApplicationController
  skip_before_action :verify_authenticity_token

  def actions
    case params[:action]
    when 'update'
      update
    when 'delete'
      delete
    when 'undelete'
      undelete
    else
      create
    end
  end

  def discovery
    render json: {}
  end

  def create
    h = params[:type] || 'h-' + (params[:h] || 'entry')
    #categories = params[:properties].try(:[], :category) || Array(params[:category])

    name = params[:properties].try(:[], :name) || Array(params[:name])
    content = params[:properties].try(:[], :content) || Array(params[:content])
    #photo = params[:properties].try(:[], :photo) || Array(params[:photo])

    raise unless h == 'h-entry'

    post = Post.new
    post.kind = name.first.present? ? :article : :note
    post.title = name.first
    post.body = content.first
    post.save

    response.headers['location'] = post_url(post)
    head :created
  end
end
