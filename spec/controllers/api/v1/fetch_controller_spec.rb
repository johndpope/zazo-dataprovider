require 'rails_helper'

RSpec.describe Api::V1::FetchController, type: :controller do
  def send_http_request(method, entity, prefix, name, options = {})
    send method, :show, options.merge(entity: entity, prefix: prefix, name: name)
  end

  [:get, :post].each do |method|
    describe "#{method.upcase} users entity" do
      before do
        authenticate_with_http_digest { send_http_request method, *params }
      end

      context 'existing query, valid options' do
        let(:params) { [:users, :prefix, :sample_query, is_valid: true] }

        it { expect(response).to have_http_status(:success) }
        it { expect(json_response).to eq 'result' => 'success' }
      end

      context 'existing query, invalid options' do
        let(:params) { [:users, :prefix, :sample_query, is_valid: false] }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(json_response).to eq 'errors' => { 'is_valid' => ['is not valid']} }
      end

      context 'nonexistent query' do
        let(:params) { [:users, :prefix, :nonexistent] }

        it { expect(response).to have_http_status(:not_found) }
        it { expect(json_response).to eq 'errors' => 'Users::Prefix::Nonexistent class not found' }
      end
    end
  end
end
