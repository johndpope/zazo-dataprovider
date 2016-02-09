require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller(ApplicationController) do
    def index; end
  end

  context 'unauthorized' do
    before do
      get :index
    end

    it { expect(response).to have_http_status(:unauthorized) }
  end

  context 'success' do
    before do
      authenticate_with_http_digest { get :index }
    end

    it { expect(response).to have_http_status(:success) }
  end
end
