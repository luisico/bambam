require 'rails_helper'

RSpec.describe StreamServicesController do
  describe 'show' do
    context "as a sign_in user" do
      before { stub_sign_in }

      context "with invalid record or file" do
        it "should respond not found when record is not found" do
          get :show, id: 1
          expect(response).to be_not_found
        end

        it "should respond not found when file is not found" do
          track = FactoryGirl.create(:track)
          File.unlink track.full_path
          get :show, id: track
          expect(response).to be_not_found
        end

        it "should respond forbidden when the format is non-standard" do
          track = FactoryGirl.create(:track)
          get :show, id: track, format: 'non'
          expect(response).to be_forbidden
          File.unlink track.full_path
        end

        it "should respond not found when file is empty" do
          track = FactoryGirl.create(:track)
          Pathname.new(track.full_path).truncate(0)
          get :show, id: track
          File.unlink(track.full_path)

          expect(response).to be_not_found
        end
      end

      context "with valid record and file" do
        before(:all) do
          @track = FactoryGirl.create(:track)
          @path = @track.full_path
          @text = ['word1', 'word2', 'word3', 'word4']
          File.open(@path, 'wb') { |f| f.write @text.pack('A*A*A*A*') }
        end

        after(:all) { File.unlink(@path) if File.exist?(@path) }

        before do
          headers = {
            'Accept' => 'text/plain',
            'User-Agent' => 'IGV Version 2.3.32 (37)03/17/2014 08:51 PM',
            'Cache-Control' => 'no-cache',
            'Pragma' => 'no-cache',
            'Connection' => 'keep-alive'
            # 'Host' => 'localhost:3000'
          }
          @request.headers.merge! headers
        end

        context "HEAD" do
          it "should be successful" do
            head :show, id: @track
            expect(response.status).to eq 200
          end

          it "should return right headers" do
            head :show, id: @track
            expect(response.headers['Content-Type']).to match 'text/plain'
            expect(response.headers['Content-Length']).to eq 20
          end

          it "should not return return a file" do
            head :show, id: @track
            expect(response.body).to be_blank
            expect(response).to render_template nil
          end
        end

        context "GET" do
          context "without range request" do
            it "should be successful" do
              get :show, id: @track
              expect(response.status).to eq 200
            end

            it "should return right headers" do
              get :show, id: @track
              expect(response.headers['Content-Type']).to match 'text/plain'
              expect(response.headers['Content-Length']).to be_nil
              expect(response.headers['Content-Disposition']).to eq "attachment; filename=\"#{File.basename(@path)}\""
              expect(response.headers['Content-Transfer-Encoding']).to eq 'binary'
            end

            it "should return return the file" do
              get :show, id: @track
              expect(response.body).to eq @text.pack('A*A*A*A*')
            end
          end

          context "with range request" do
            before { @request.headers.merge!({'Range' => 'bytes=0-4'}) }

            it "should be successful" do
              get :show, id: @track
              expect(response.status).to eq 206
            end

            it "should return right headers" do
              get :show, id: @track
              expect(response.headers['Content-Type']).to match 'text/plain'
              expect(response.headers['Content-Length']).to eq 5
              expect(response.headers['Content-Disposition']).to eq "attachment; filename=\"#{File.basename(@path)}\""
              expect(response.headers['Accept-Ranges']).to eq 'bytes'
              expect(response.headers['Content-Range']).to eq "bytes 0-4/20"
              expect(response.headers['Content-Transfer-Encoding']).to eq 'binary'
            end

            it "should return the partial file" do
              ranges = ['0-4', '5-9', '10-14', '15-19']
              ranges.each_index do |idx|
                @request.headers.merge!({'Range' => "bytes=#{ranges[idx]}"})
                get :show, id: @track
                expect(response.body).to eq @text[idx]
              end
            end

            context "not satisfiable" do
              before { @request.headers.merge!({'Range' => 'bytes=1000-2000'}) }

              [
                'bytes=1000-2000',
                'bytes=',
                ''
              ].each do |range|
                context "range '#{range}'" do
                  it "should return 416" do
                    get :show, id: @track
                    expect(response.status).to eq 416
                  end

                  it "should return a file" do
                    get :show, id: @track
                    expect(response.body).to be_blank
                    expect(response).to render_template nil
                  end
                end
              end
            end
          end
        end
      end
    end

    context "as a visitor with valid access_token" do
      it "should be successful" do
        expect(controller).to receive(:has_access_token?).and_return(true)
        expect(controller).not_to receive(:authenticate_user!)

        track = FactoryGirl.create(:track)
        share_link = FactoryGirl.create(:share_link, track_id: track.id)

        get :show, id: track.id, access_token: share_link.access_token
        expect(response.status).to eq 200
      end
    end

    context "as a visitor" do
      it "should redirect to the sign in page" do
        expect(controller).to receive(:has_access_token?).and_return(false)
        expect(controller).to receive(:authenticate_user!).and_call_original

        get :show, id: 1
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "#has_access_token?" do
    before do
      @track = FactoryGirl.create(:track)
      @share_link = FactoryGirl.create(:share_link, track_id: @track.id)
    end

    it "should be true with valid access token" do
      controller.params = {access_token: @share_link.access_token, id: "#{@track.id}"}
      expect(controller.send(:has_access_token?)).to be true
    end

    it "should be false with invalid access token" do
      controller.params = {access_token: "invalid_token", id: "#{@track.id}"}
      expect(controller.send(:has_access_token?)).to be false
    end

    it "should be false with expired access token" do
      @share_link.update_attribute(:expires_at, DateTime.yesterday)
      controller.params = {access_token: @share_link.access_token, id: "#{@track.id}"}
      expect(controller.send(:has_access_token?)).to be false
    end

    it "should be false with no access token" do
      controller.params = { id: "#{@track.id}" }
      expect(controller.send(:has_access_token?)).to be false
    end

    it "should be false with non-existant track" do
      controller.params = {access_token: @share_link.access_token, id: "9999"}
      expect(controller.send(:has_access_token?)).to be false
    end

    it "should be false with different track" do
      controller.params = {access_token: @share_link.access_token, id: "#{FactoryGirl.create(:track).id}"}
      expect(controller.send(:has_access_token?)).to be false
    end

    it "should be call sanitized_access_token when access_token is present" do
      expect_any_instance_of(StreamServicesController).to receive(:sanitized_access_token)
      controller.params = {access_token: '123'}
      controller.send(:has_access_token?)
    end

    it "should not be call sanitized_access_token when access_toek not present" do
      expect_any_instance_of(StreamServicesController).not_to receive(:sanitized_access_token)
      controller.params = {id: "#{@track.id}"}
      controller.send(:has_access_token?)
    end
  end

  describe "#find_path_with_format" do
    before(:all) do
      @path = File.join("tmp", "tests", "track_find_paths.bam")
      cp_track @path
    end

    after(:all) { File.unlink(@path) if File.exist?(@path) }

    context "without format" do
      it "should point to the file if it exists" do
        path = controller.send(:find_path_with_format, @path, '')
        expect(path).to eq @path
      end

      it "should raise 'not found'error if file does not exists" do
        expect {
          controller.send(:find_path_with_format, '/tmp/missing_file.bam', '')
        }.to raise_error Errno::ENOENT
      end
    end

    context "with regular format" do
      it "should point to the file if it exists" do
        path = controller.send(:find_path_with_format, @path, 'bam')
        expect(path).to eq @path
      end

      it "should raise 'not found' error if file does not exists" do
        expect {
          controller.send(:find_path_with_format, '/tmp/missing_file.bam', 'bam')
        }.to raise_error Errno::ENOENT
      end
    end

    context "with alternate format" do
      it "should point to the auxiliary file if present with a second extension" do
        auxpath = @path + '.bai'
        cp_track auxpath, 'bai'
        path = controller.send(:find_path_with_format, @path, 'bai')
        expect(path).to eq auxpath
        File.unlink(auxpath)
      end

      it "should point to the auxiliary file if present with an alternate extension" do
        auxpath = @path.sub('.bam', '.bai')
        cp_track auxpath, 'bai'
        path = controller.send(:find_path_with_format, @path, 'bai')
        expect(path).to eq auxpath
        File.unlink(auxpath)
      end

      it "should raise 'not found' error when auxiliary file does not exist" do
        expect {
          controller.send(:find_path_with_format, @path, 'bai')
        }.to raise_error Errno::ENOENT
      end
    end

    context "acceptable auxiliary files" do
      %w(bai bam.bai).each do |format|
        it "should allow #{format} extension" do
          auxpath = @path + '.bai'
          cp_track auxpath, 'bai'
          expect {
            controller.send(:find_path_with_format, @path, format)
          }.not_to raise_error
          File.unlink(auxpath)
        end
      end

      it "should raise 'permission denied' when format is out of scope" do
        expect {
          controller.send(:find_path_with_format, @path, 'non')
        }.to raise_error Errno::EACCES
      end
    end
  end

  describe "#sanitized_access_token" do
    it "should remove everything in token after the ." do
      controller.params = {access_token: '123.bam.4646.jam'}
      expect(controller.send(:sanitized_access_token)).to eq '123'
    end

    it "should call #set_format when no format is set" do
      expect_any_instance_of(StreamServicesController).to receive(:set_format)
      controller.params = {access_token: '123456789'}
      controller.send(:sanitized_access_token)
    end

    it "should not call #set_format when format is already set" do
      expect_any_instance_of(StreamServicesController).not_to receive(:set_format)
      controller.params = {access_token: '123456789', format: 'abc'}
      controller.send(:sanitized_access_token)
    end
  end

  describe "set_format" do
    it "should set format when extension present" do
      controller.params = {access_token: '123456789.abc'}
      controller.send(:set_format)
      expect(controller.params[:format]).to eq 'abc'
    end

    it "should set format to terminal format when extension present" do
      controller.params = {access_token: '123456789.abc.def'}
      controller.send(:set_format)
      expect(controller.params[:format]).to eq 'def'
    end

    it "should not set format parameter if no extension present" do
      controller.params = {access_token: '123456789'}
      controller.send(:set_format)
      expect(controller.params[:format]).to eq nil
    end
  end

  # As a reminder of the inner workins of Rack::Utils.byte_ranges
  describe "Rack::Utils.byte_ranges" do
    it "should return nil if the header is missing or incorrect" do
      [
        {},
        {'HTTP_RANGE' => ''},
        {'HTTP_RANGE' => nil},
        {'HTTP_RANGE' => []},
        {'HTTP_RANGE' => 'bytes'},
        {'HTTP_RANGE' => 'bytes='},
        {'HTTP_RANGE' => 'bytes=0'},
        {'HTTP_RANGE' => 'bytes=1'},
        {'HTTP_RANGE' => 'bytes=9'}
      ].each do |headers|
        expect(Rack::Utils.byte_ranges(headers, 10)).to be_nil
      end
    end

    it "should return an empty array if none of the ranges are satisfiable" do
      [
        {'HTTP_RANGE' => 'bytes=10-'},
        {'HTTP_RANGE' => 'bytes=10-12'}
      ].each do |headers|
        expect(Rack::Utils.byte_ranges(headers, 10)).to be_empty
      end
    end

    it "should return a correct range" do
      [
        [{'HTTP_RANGE' => 'bytes=1-'},   [1..9]],
        [{'HTTP_RANGE' => 'bytes=-2'},   [8..9]],
        [{'HTTP_RANGE' => 'bytes=0-10'}, [0..9]],
        [{'HTTP_RANGE' => 'bytes=-12'},  [0..9]]
      ].each do |headers|
        expect(Rack::Utils.byte_ranges(headers[0], 10)).to eq headers[1]
      end
    end

    it "should return multiple range" do
      headers = {'HTTP_RANGE' => 'bytes=1-3,4-6,8-9'}
      expect(Rack::Utils.byte_ranges(headers, 10)).to eq [1..3, 4..6, 8..9]
    end
  end
end
