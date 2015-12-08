require 'rails_helper'

RSpec.describe LociController, type: :controller do
  describe "filters" do
    it { is_expected.to use_before_action :authenticate_user! }
  end

  before do
    @user = FactoryGirl.create(:user)
    @track = FactoryGirl.create(:track, owner: @user)
  end

  describe "Patch 'update'" do
    before { @locus = FactoryGirl.create(:track_locus, locusable_id: @track, user: @user) }

    context "as a user" do
      before { sign_in @user }

      context "with valid parameters" do
        it "should be a success" do
          patch :update, id: @locus, locus: {range: '456'}, format: :js
          expect(response).to be_success
        end

        it "should update attributes'" do
          patch :update, id: @locus, locus: {range: '456'}, format: :js
          @locus.reload
          expect(@locus.range).to eq '456'
        end
      end

      context "failed update" do
        before { allow_any_instance_of(Locus).to receive(:save).and_return(false) }

        it "should not be a success" do
          patch :update, id: @locus, locus: {locus: '456'}, format: :js
          expect(response.status).to eq 422
        end

        it "should not update attribute" do
          expect {
            patch :update, id: @locus, locus: {locus: '456'}, format: :js
            @track.reload
          }.not_to change(@track, :name)
        end
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        patch :update, id: @locus, locus: {range: '456'}, format: :js
        expect(response.status).to be 401
      end

      it "should not change the track's attributes" do
        expect{
          patch :update, id: @locus, locus: {range: '456'}, format: :js
        }.not_to change(@locus, :range)
      end
    end
  end
end
