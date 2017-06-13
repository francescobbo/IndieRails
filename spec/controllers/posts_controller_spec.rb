require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe '#index' do
    it 'responds with 200 (OK)' do
      get :index
      expect(response).to be_successful
    end
  end

  describe '#show' do
    let(:post) { FactoryGirl.create(:post) }

    context 'when the ID is a slug for a post' do
      it 'responds with 200 (OK)' do
        get :show, params: { id: post.slug }
        expect(response).to be_successful
      end
    end

    context 'when the ID is not a slug for a post' do
      it 'responds with 404 (Not Found), by triggering a RecordNotFound exception' do
        expect { get :show, params: { id: 'just-a-random-slug' } }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the ID a slug for a deleted post' do
      let(:post) { FactoryGirl.create(:post, deleted: true) }

      it 'responds with 410 (Gone)' do
        get :show, params: { id: post.slug }
        expect(response.status).to eq 410
      end
    end
  end
end
