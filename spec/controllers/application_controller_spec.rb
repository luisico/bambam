require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      raise CanCan::AccessDenied
    end
  end

  describe "CanCan AccessDenied exceptions" do
    it "redirect to the tracks page" do
      get :index
      expect(response).to redirect_to(tracks_path)
    end
  end
end
