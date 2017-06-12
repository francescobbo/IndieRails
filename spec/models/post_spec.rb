require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'when the body is changed' do
    it 'renders body as markdown' do
      post = Post.new
      post.body = '_hello_ **world**'
      expect(post.rendered_body.strip).to eq '<p><em>hello</em> <strong>world</strong></p>'
    end
  end

  context 'when the kind is note' do
    subject { FactoryGirl.build(:post, kind: :note) }
    it { is_expected.to validate_presence_of(:body) }
  end

  context 'when the kind is article' do
    subject { FactoryGirl.build(:post, kind: :article) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
  end
end
