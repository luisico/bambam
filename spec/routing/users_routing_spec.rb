require "spec_helper"

describe "Users" do
  describe "routes through devise" do
    it "routes to sessions" do
      # For sign_out :get is used in test environtment, :delete is used in production
      assert_routing({ path: '/users/sign_in',  method: :get },  { controller: 'devise/sessions', action: 'new'})
      assert_routing({ path: '/users/sign_in',  method: :post }, { controller: 'devise/sessions', action: 'create'})
      assert_routing({ path: '/users/sign_out', method: :get },  { controller: 'devise/sessions', action: 'destroy'})
    end

    it "routes to password" do
      assert_routing({ path: '/users/password',      method: :post }, { controller: 'devise/passwords', action: 'create'})
      assert_routing({ path: '/users/password/new',  method: :get },  { controller: 'devise/passwords', action: 'new'})
      assert_routing({ path: '/users/password/edit', method: :get },  { controller: 'devise/passwords', action: 'edit'})
      assert_routing({ path: '/users/password',      method: :put },  { controller: 'devise/passwords', action: 'update'})
    end

    it "routes to registration" do
      assert_routing({ path: '/users/cancel',  method: :get },    { controller: 'devise/registrations', action: 'cancel'})
      assert_routing({ path: '/users',         method: :post },   { controller: 'devise/registrations', action: 'create'})
      assert_routing({ path: '/users/sign_up', method: :get },    { controller: 'devise/registrations', action: 'new'})
      assert_routing({ path: '/users/edit',    method: :get },    { controller: 'devise/registrations', action: 'edit'})
      assert_routing({ path: '/users',         method: :put },    { controller: 'devise/registrations', action: 'update'})
      assert_routing({ path: '/users',         method: :delete }, { controller: 'devise/registrations', action: 'destroy'})
    end
  end
end
