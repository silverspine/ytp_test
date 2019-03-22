require 'rails_helper'

RSpec.describe 'Accounts API', type: :request do
  # initialize test data 
  let!(:admin) { create(:user, admin: true) }
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:other_user) { create(:user) }
  let!(:accounts) { create_list(:account, 10, user_id: user_id) }
  let(:account) { accounts.first }
  let(:account_id) { account.id }
  # authorize request
  let(:headers) { valid_headers }

  # Test suite for GET /accounts
  describe 'GET /users/:user_id/accounts' do
    # make HTTP get request before each example
    before { get "/users/#{user_id}/accounts", params: {}, headers: headers  }

    it 'returns accounts' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(11)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /accounts/:id
  describe 'GET /users/:user_id/accounts/:id' do
    before { get "/users/#{user_id}/accounts/#{account_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the account' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(account_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:account_id) { 400 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Account/)
      end
    end
  end

  # Test suite for POST /accounts
  describe 'POST /users/:user_id/accounts' do
    # valid payload
    let(:valid_attributes) { { CLABE: '1234567890abcdf12', user_id: user.id.to_s }.to_json }
    let(:headers) { admin_headers }
    
    before { post "/users/#{user_id}/accounts", params: valid_attributes, headers: headers }
    
    context 'when the request is valid' do
      it 'creates an account' do
        expect(json['CLABE']).to eq('1234567890abcdf12')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the CLABE is already taken' do
      let(:valid_attributes) { { CLABE: accounts.first.CLABE }.to_json }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Clabe has already been taken/)
      end
    end

    context 'when the user is not an admin' do
      let(:headers) { valid_headers }
      
      it 'returns an Unauthorized request error' do
        expect(response.body)
        .to match(/Unauthorized request/)
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Test suite for PUT /accounts/:id
  describe 'PUT /users/:user_id/accounts/:id' do
    let(:valid_attributes) { { CLABE: 'new valid CLABE' }.to_json }
    before { put "/users/#{user_id}/accounts/#{account_id}", params: valid_attributes, headers: headers }

    context 'when the record exists' do
      let(:headers) { admin_headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the user is not an admin' do
      it 'returns an Unauthorized request error' do
        expect(response.body)
        .to match(/Unauthorized request/)
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Test suite for DELETE /accounts/:id
  describe 'DELETE /users/:user_id/accounts/:id' do
    before { delete "/users/#{user_id}/accounts/#{account_id}", headers: headers }

    context 'when the record exists' do
      let(:headers) { admin_headers }
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the user is not an admin' do
      it 'returns an Unauthorized request error' do
        expect(response.body)
        .to match(/Unauthorized request/)
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
end
