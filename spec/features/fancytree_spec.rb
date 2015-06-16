require 'rails_helper'

RSpec.feature "fancytree" do
  before do
    @manager = FactoryGirl.create(:manager)
  end

  scenario "Manager signs in" do
    sign_in @manager
    expect(page).to have_text("Signed in successfully.")
  end
end
