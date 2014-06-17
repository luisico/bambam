require "spec_helper"

describe GroupsHelper do
  describe "#member_check_box" do
    before do
      @owner = FactoryGirl.create(:user)
      @members = FactoryGirl.create_list(:user, 2)
      @member = @members.first
      @user = FactoryGirl.create_list(:user, 2).first
      @group = FactoryGirl.create(:group, owner: @owner, members: @members)
    end

    it "for group owner" do
      expect(helper.member_check_box(@group, @owner)).to match /<input .* type="checkbox".*>/
      expect(helper.member_check_box(@group, @owner)).to match /disabled="disabled"/
      expect(helper.member_check_box(@group, @owner)).to match /checked="checked"/
      expect(helper.member_check_box(@group, @owner)).to match /<input .* type="hidden"/
      expect(helper.member_check_box(@group, @owner)).to match /http:\/\/gravatar.com\/avatar\//
      expect(helper.member_check_box(@group, @owner)).to match /#{@owner.email}/
      expect(helper.member_check_box(@group, @owner)).to match /\(owner\)/
    end

    it "for group members" do
      expect(helper.member_check_box(@group, @member)).to match /<input .* type="checkbox".*>/
      expect(helper.member_check_box(@group, @member)).not_to match /disabled=/
      expect(helper.member_check_box(@group, @member)).to match /checked="checked"/
      expect(helper.member_check_box(@group, @member)).not_to match /<input .* type="hidden"/
      expect(helper.member_check_box(@group, @member)).to match /http:\/\/gravatar.com\/avatar\//
      expect(helper.member_check_box(@group, @member)).to match /#{@member.email}/
      expect(helper.member_check_box(@group, @member)).not_to match /\(owner\)/
    end

    it "for non group members" do
      expect(helper.member_check_box(@group, @user)).to match /<input .* type="checkbox".*>/
      expect(helper.member_check_box(@group, @user)).not_to match /disabled=/
      expect(helper.member_check_box(@group, @user)).not_to match /checked=/
      expect(helper.member_check_box(@group, @user)).not_to match /<input .* type="hidden"/
      expect(helper.member_check_box(@group, @user)).to match /http:\/\/gravatar.com\/avatar\//
      expect(helper.member_check_box(@group, @user)).to match /#{@user.email}/
      expect(helper.member_check_box(@group, @user)).not_to match /\(owner\)/
    end
  end
end
