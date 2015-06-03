require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe "#avatar_url" do
    before do
      @user = FactoryGirl.create(:user)
      @hexdigest = Digest::MD5.hexdigest(@user.email.downcase)
    end

    it "needs a user object as argument" do
      expect{helper.avatar_url}.to raise_error(ArgumentError)
    end

    it "returns a url and defaults to size 48" do
      expect(helper.avatar_url(@user)).to eq "http://gravatar.com/avatar/#{@hexdigest}.png?s=48&d=retro"
    end

    it "accepts a size argument" do
      expect(helper.avatar_url(@user, 70)).to eq "http://gravatar.com/avatar/#{@hexdigest}.png?s=70&d=retro"
    end
  end
end
