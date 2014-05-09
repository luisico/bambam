require 'spec_helper'

describe StreamServicesController do
  describe 'show' do
    context "as a sign_in user" do
      before { stub_sign_in }

      context "with invalid record" do
        it "should respond not found when record is not found" do
          get :show, id: 1
          expect(response).to be_not_found
        end

        it "should respond not found when file is not found" do
          track = FactoryGirl.create(:track)
          get :show, id: track
          expect(response).to be_not_found
        end

        it "should respond not found when file is empty" do
          track = FactoryGirl.create(:track, path: 'tmp/emptytrack.ext')
          File.open(track.path, 'wb') { |f| f.truncate(0) }
          get :show, id: track
          File.unlink(track.path) if File.exist?(track.path)

          expect(response).to be_not_found
        end
      end

      context "with valid record and file" do
        before(:all) do
          @path = 'tmp/mytrack.ext'
          @text = ['word1', 'word2', 'word3', 'word4']
          File.open(@path, 'wb') { |f| f.write @text.pack('A*A*A*A*') }
        end

        after(:all) { File.unlink(@path) if File.exist?(@path) }

        before do
          @track = FactoryGirl.create(:track, path: @path)
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

        context "and extension format" do
          before do
            @ext = 'ext2'
            @extpath = "#{@path}.#{@ext}"
            File.unlink(@extpath) if File.exist?(@extpath)
          end

          after {File.unlink(@extpath) if File.exist?(@extpath) }

          it "should return file if present" do
            File.open(@extpath, 'wb') { |f| f.write ['extension'].pack('A*') }
            get :show, id: @track, format: @ext

            expect(response.status).to eq 200
          end

          it "should return not found if file is empty" do
            File.open(@extpath, 'wb') { |f| f.truncate(0) }
            get :show, id: @track, format: @ext
            expect(response.status).to eq 404
          end

          it "should return not found if file is not present" do
            get :show, id: @track, format: @ext
            expect(response.status).to eq 404
          end

          it "should return the file if format is nil" do
            get :show, id: @track, format: nil
            expect(response.status).to eq 200
          end

          it "should respond forbidden when format is out of scope" do
            formats = [
              '',
              '/../Gemfile', '../Gemfile', './Gemfile', '/Gemfile',
              '.%2FGemfile'
            ]

            # For a file
            formats.each do |format|
              get :show, id: @track, format: format
              expect(response).to be_forbidden, "#{@track.path} . #{format}"
            end

            # For a directory
            @track.update(path: 'tmp')
            formats.each do |format|
              get :show, id: @track, format: format
              expect(response).to be_forbidden, "#{@track.path} . #{format}"
            end

            # For a directory with trailing slash
            @track.update(path: 'tmp/')
            formats.each do |format|
              get :show, id: @track, format: format
              expect(response).to be_forbidden, "#{@track.path} . #{format}"
            end
          end


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
              expect(response.headers['Content-Disposition']).to eq "inline; filename=\"#{@path}\""
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
              expect(response.headers['Content-Disposition']).to eq "inline; filename=\"#{@path}\""
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

    context "as a visitor" do
      it "should redirect to the sign in page" do
        get :show, id: 1
        expect(response).not_to be_success
        expect(response).to redirect_to new_user_session_url
      end
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
