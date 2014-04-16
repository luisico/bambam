require 'spec_helper'

describe StreamServicesController do
  describe 'show' do
    # TODO: authz users only

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
        track = FactoryGirl.create(:track, path: 'tmp/emptytrack')
        @path = track.path
        File.open(@path, 'wb') do |f|
          f.truncate(0)
        end
        get :show, id: track
        File.unlink(@path) if File.exist?(@path)

        expect(response).to be_not_found
      end
    end

    context "with valid record and file" do
      before(:all) do
        @track = FactoryGirl.create(:track, path: 'tmp/mytrack')
        @path = @track.path
        @text = ['word1', 'word2', 'word3', 'word4']
        File.unlink(@path) if File.exist?(@path)
        File.open(@path, 'wb') do |f|
          f.write @text.pack('A*A*A*A*')
        end
      end

      after(:all) do
        File.unlink(@path) if File.exist?(@path)
      end

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

      context "and extension format" do
        it "should return file.ext if present" do
          File.open("#{@path}.ext", 'wb') do |f|
            f.write ['ext'].pack('A*')
          end
          head :show, id: @track.id, format: 'ext'

          expect(response.status).to eq 200
        end

        it "should return not found if file.ext is empty" do
          File.open("#{@path}.ext", 'wb') do |f|
            f.truncate(0)
          end
          head :show, id: @track.id, format: 'ext'
          expect(response.status).to eq 404
        end

        it "should return not found if file.ext is not present" do
          head :show, id: @track.id, format: 'ext'
          expect(response.status).to eq 404
        end
      end

      context "HEAD" do
        it "should be successful" do
          head :show, id: @track.id
          expect(response.status).to eq 200
        end

        it "should return right headers" do
          head :show, id: @track.id
          expect(response.headers['Content-Type']).to match 'text/plain'
          expect(response.headers['Content-Length']).to eq 20
        end

        it "should not return return a file" do
          head :show, id: @track.id
          expect(response.body).to be_blank
          expect(response).to render_template nil
        end
      end

      context "GET" do
        context "without range request" do
          it "should be successful" do
            get :show, id: @track.id
            expect(response.status).to eq 200
          end

          it "should return right headers" do
            get :show, id: @track.id
            expect(response.headers['Content-Type']).to match 'text/plain'
            expect(response.headers['Content-Length']).to be_nil
            expect(response.headers['Content-Disposition']).to eq "inline; filename=\"#{@path}\""
            expect(response.headers['Content-Transfer-Encoding']).to eq 'binary'
          end

          it "should return return the file" do
            get :show, id: @track.id
            expect(response.body).to eq @text.pack('A*A*A*A*')
          end
        end

        context "with range request" do
          before do
            @request.headers.merge!({'Range' => 'bytes=0-4'})
          end

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
            before do
              @request.headers.merge!({'Range' => 'bytes=1000-2000'})
            end

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

    context "Rack::Utils.byte_ranges" do
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
end
