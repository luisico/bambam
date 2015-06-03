require 'rails_helper'

RSpec.describe ExceptionsController do
  describe "not found exception" do
    it "renders the template" do
      skip
      get '/not_found'
      render
      expect(response).to render_template :show
    end
  end
end
