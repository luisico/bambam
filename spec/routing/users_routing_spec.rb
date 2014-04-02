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
      assert_routing({ path: '/users/edit',    method: :get }, { controller: 'devise_invitable/registrations', action: 'edit'})
      assert_routing({ path: '/users',         method: :put }, { controller: 'devise_invitable/registrations', action: 'update'})
      assert_routing({ path: '/users/sign_up', method: :get }, { controller: 'users', action: 'new' })
      assert_routing({ path: '/users/cancel',  method: :get }, { controller: 'users', action: 'cancel' })
    end

    it "routes to invitations" do
      assert_routing({ path: '/users/invitation/accept', method: :get },  { controller: 'devise/invitations', action: 'edit'})
      assert_routing({ path: '/users/invitation',        method: :post }, { controller: 'devise/invitations', action: 'create'})
      assert_routing({ path: '/users/invitation/new',    method: :get },  { controller: 'devise/invitations', action: 'new'})
      assert_routing({ path: '/users/invitation',        method: :put },  { controller: 'devise/invitations', action: 'update'})
    end
  end

  describe "normal routes" do
    it "index" do
      assert_routing({ path: '/users', method: :get }, { controller: 'users', action: 'index' })
    end
  end
end
