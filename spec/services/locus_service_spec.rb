require 'rails_helper'

RSpec.describe LocusService do
  describe "#locus_for" do
    before do
      @user = FactoryGirl.create(:user)
      class FakeModel
        def id
          "1"
        end
      end
      class FakeController < ApplicationController
        include LocusService
      end
      @object = FakeModel.new
      @controller = FakeController.new
    end

    it "creates new locus for object and user when non exists" do
      expect {
        @controller.locus_for @user, @object
      }.to change(Locus, :count).by(1)
      expect(Locus.last.locusable_id).to eq 1
      expect(Locus.last.locusable_type).to eq "FakeModel"
      expect(Locus.last.user).to eq @user
    end

    it "does not create new tracks user for track and user when it already exists" do
      expect {
        @controller.locus_for @user, @object
      }.to change(Locus, :count).by(1)
      expect {
        @controller.locus_for @user, @object
      }.not_to change(Locus, :count)
    end
  end
end

