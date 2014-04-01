require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      raise CanCan::AccessDenied
    end
  end

  describe "CanCan AccessDenied exceptions" do
    it "redirect to the root page" do
      get :index
      expect(response).to redirect_to(root_path)
    end
  end
end
