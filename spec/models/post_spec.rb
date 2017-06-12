require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'when the body is changed' do
    it 'renders body as markdown' do
      post = Post.new
      post.body = '_hello_ **world**'
      expect(post.rendered_body.strip).to eq '<p><em>hello</em> <strong>world</strong></p>'
    end
  end
end
