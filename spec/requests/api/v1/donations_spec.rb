require 'rails_helper'

RSpec.describe "Donations API", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base) }
  let(:headers) { { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" } }

  let(:valid_attributes) do
    {
      donation: {
        amount_cents: 5000,
        currency: 'EUR',
        project_id: project.id
      }
    }
  end

  describe "POST /api/v1/donations" do
    context "with valid attributes" do
      it "creates a donation and returns 201" do
        post "/api/v1/donations", params: valid_attributes.to_json, headers: headers

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["amount_cents"]).to eq(5000)
        expect(json_response["project_id"]).to eq(project.id)
        expect(json_response["user_id"]).to eq(user.id)
      end
    end

    context "with missing amount" do
      it "returns 422 Unprocessable Entity" do
        invalid_params = { donation: { amount_cents: nil, currency: 'EUR', project_id: project.id } }

        post "/api/v1/donations", params: invalid_params.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response).to include("errors")
      end
    end

    context "without authentication" do
      it "returns 401 Unauthorized" do
        post "/api/v1/donations", params: valid_attributes.to_json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/v1/donations/user_total" do
    context "when user has donations" do
      before do
        create(:donation, user: user, project: project, amount_cents: 1000, currency: 'EUR') # €10
        create(:donation, user: user, project: project, amount_cents: 5000, currency: 'EUR') # €50
      end

      it "returns the correct total donation amount" do
        params = { currency: 'EUR' }
        get "/api/v1/donations/user_total", headers: headers, params: params

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["amount_cents"]).to eq(6000) # €10 + €50 = €60
        expect(json_response["currency"]).to eq("EUR")
      end
    end

    context "when user has no donations" do
      it "returns 0 amount_cents" do
        params = { currency: 'EUR' }
        get "/api/v1/donations/user_total", headers: headers, params: params

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["amount_cents"]).to eq(0)
        expect(json_response["currency"]).to eq("EUR")
      end
    end

    context "when user is not authenticated" do
      it "returns 401 Unauthorized" do
        get "/api/v1/donations/user_total"

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Unauthorized")
      end
    end
  end
end
