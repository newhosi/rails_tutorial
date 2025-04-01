require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /help" do
    it "renders the help template" do
      get help_url
      expect(response).to render_template(:help)
    end
  end

  describe "GET /about" do
    it "renders the about template" do
      get about_url
      expect(response).to render_template(:about)
    end
  end

  describe "GET /contact" do
    it "renders the contact template" do
      get contact_url
      expect(response).to render_template(:contact)
    end
  end
end
