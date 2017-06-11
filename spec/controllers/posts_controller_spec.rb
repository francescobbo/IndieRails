require 'rails_helper'

describe PostsController do
  describe '#index' do
    it 'responds with 200 (OK)' do
      get :index
      expect(response).to be_successful
    end
  end
end
