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
        invalid_params = { donation: { amount_cents: nil, project_id: project.id } }

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
end
