require 'rails_helper'

RSpec.describe "ProjectsUsers" do
  describe "routes to" do
    it "the update action" do
      assert_routing({ path: '/projects_users/1', method: :patch},    { controller: 'projects_users', action: 'update', id: '1'})
    end
  end
end
