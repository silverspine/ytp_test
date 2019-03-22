require 'rails_helper'

RSpec.describe 'Movements API', type: :request do
  let(:admin) { create(:user, admin: true) }
  let(:user) { create(:user) }
  let(:user_id) { user.id }
  let!(:account) { create(:account, user_id: user_id) }
  let!(:movements) { create_list(:movement, 20, account_id: account.id) }
  let(:account_id) { account.id }
  let(:id) { movements.first.id }
  let(:headers) { valid_headers }

  # Test suite for GET /users/:user_id/accounts/:account_id/movements
  describe 'GET /users/:user_id/accounts/:account_id/movements' do
    before { get "/users/#{user_id}/accounts/#{account_id}/movements", params: {}, headers: headers }

    context 'when account exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all account movements' do
        expect(json.size).to eq(20)
      end
    end

    context 'when account does not exist' do
      let(:account_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Account/)
      end
    end
  end

  # Test suite for GET /users/:user_idaccounts/:account_id/movements/:id
  describe 'GET /users/:user_id/accounts/:account_id/movements/:id' do
    before { get "/users/#{user_id}/accounts/#{account_id}/movements/#{id}", params: {}, headers: headers }

    context 'when account movement exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the movement' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when account movement does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Movement/)
      end
    end
  end

  # Test suite for POST /users/:user_id/accounts/:account_id/movements
  describe 'POST /users/:user_id/accounts/:account_id/movements' do
    let(:valid_attributes) { { amount: 300.00, reference: "zxcvbnmsadfhjglkqweryt" }.to_json }

    before { post "/users/#{user_id}/accounts/#{account_id}/movements", params: valid_attributes, headers: headers }

    context 'when request attributes are valid' do
      let(:headers) { admin_headers }
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      let(:headers) { admin_headers }
      
      before { post "/users/#{user_id}/accounts/#{account_id}/movements", params: {}, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Amount can't be blank/)
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

  # Test suite for PUT /users/:user_id/accounts/:account_id/movements/:id
  describe 'PUT /users/:user_id/accounts/:account_id/movements/:id' do
    let(:valid_attributes) { { reference: "somethingcool" }.to_json }
    let(:headers) { admin_headers }

    before { put "/users/#{user_id}/accounts/#{account_id}/movements/#{id}", params: valid_attributes, headers: headers }

    context 'when movement exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the movement' do
        updated_movement = Movement.find(id)
        expect(updated_movement.reference).to match(/somethingcool/)
      end
    end

    context 'when the movement does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Movement/)
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

  # Test suite for DELETE /users/:user_id/accounts/:account_id/movements/:id
  describe 'DELETE /users/:user_id/accounts/:account_id/movements/:id' do
    before { delete "/users/#{user_id}/accounts/#{account_id}/movements/#{id}", params: {}, headers: headers }
    
    context 'the user is an admin' do
      let(:headers) { admin_headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'the user is not an admin' do
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
