require 'rails_helper'

RSpec.describe WebmentionsController, type: :controller do
  describe '#create' do
    context 'with valid parameters' do
      it 'responds with Created (201)' do
        post :create, params: { source: 'https://my-website.com', target: 'https://francescoboffa.com/your-website' }
        expect(response.status).to eq 201
      end
    end

    context 'with unacceptable parameters' do
      it 'responds with Bad Request (404)' do
        post :create, params: { source: 'https://my-website.com', target: 'https://facebook.com/your-website' }
        expect(response.status).to eq 400
      end
    end
  end

  describe '#show' do
    context 'when the ID references a webmention' do
      context 'when the status is created' do
        let(:webmention) { FactoryGirl.create(:webmention, status: :created) }

        it 'responds with Created (201)' do
          get :show, params: { id: webmention.id }
          expect(response.status).to eq 201
        end
      end

      context 'when the status is published' do
        let(:webmention) { FactoryGirl.create(:webmention, status: :published) }

        it 'responds with OK (200)' do
          get :show, params: { id: webmention.id }
          expect(response.status).to eq 200
        end
      end

      context 'when the status is rejected' do
        let(:webmention) { FactoryGirl.create(:webmention, status: :rejected) }

        it 'responds with Unprocessable Entity (422)' do
          get :show, params: { id: webmention.id }
          expect(response.status).to eq 422
        end
      end

      context 'when the status is removed' do
        let(:webmention) { FactoryGirl.create(:webmention, status: :removed) }

        it 'responds with Gone (410)' do
          get :show, params: { id: webmention.id }
          expect(response.status).to eq 410
        end
      end

      context 'when the status is _screwed_' do
        let(:webmention) { FactoryGirl.create(:webmention, status: :created) }

        it 'responds with Internal Server Error (500)' do
          allow_any_instance_of(Webmention).to receive(:status_response) { nil }
          get :show, params: { id: webmention.id }
          expect(response.status).to eq 500
        end
      end
    end

    context 'when the ID references a non existing webmention' do
      it 'responds with Not Found (404) through ActiveRecord::RecordNotFound' do
        expect { get :show, params: { id: 'invalid' } }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
