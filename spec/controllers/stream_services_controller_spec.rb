require 'spec_helper'

describe StreamServicesController do
  describe 'stream' do
    # TODO: authz users only

    context "when a file is not present" do
      it "should respond not found" do
        get :stream, filename: 'missing_file'

        expect(response).to be_not_found
      end
    end

    context "when a file is present" do
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

        text = ['word1', 'word2', 'word3', 'word4']
        @filename = File.join('tmp', 'test.bin')
        File.open(@filename, 'wb') do |f|
          f.write text.pack('A*A*A*A*')
        end
      end

      context "HEAD" do
        it "should be successful" do
          head :stream, filename: @filename
          expect(response.status).to eq 200
        end

        it "should return right headers" do
          head :stream, filename: @filename
          expect(response.headers['Content-Type']).to match 'text/plain'
          expect(response.headers['Content-Length']).to eq File.size(@filename)
        end

        it "should not return return a file" do
          head :stream, filename: @filename
          expect(response.body).to be_blank
          expect(response).to render_template nil
        end
      end

      context "GET" do
        context "without range request" do
          it "should be successful" do
            get :stream, filename: @filename
            expect(response.status).to eq 200
          end

          it "should return right headers" do
            get :stream, filename: @filename
            expect(response.headers['Content-Type']).to match 'text/plain'
            expect(response.headers['Content-Length']).to be_nil
            expect(response.headers['Content-Disposition']).to eq "inline; filename=\"#{@filename}\""
            expect(response.headers['Content-Transfer-Encoding']).to eq 'binary'
          end

          it "should return return the file" do
            get :stream, filename: @filename
            expect(response.body).to eq File.open(@filename){|f| f.read}
          end
        end

        context "with range request" do
          before do
            @request.headers.merge!({'Range' => 'bytes=0-3'})
          end

          it "should be successful" do
            get :stream, filename: @filename
            expect(response.status).to eq 206
          end

          it "should return right headers" do
            get :stream, filename: @filename
            expect(response.headers['Content-Type']).to match 'text/plain'
            expect(response.headers['Content-Length']).to eq 4
            expect(response.headers['Content-Disposition']).to eq "inline; filename=\"#{@filename}\""
            expect(response.headers['Accept-Ranges']).to eq 'bytes'
            expect(response.headers['Content-Range']).to eq "bytes 0-3/#{File.size(@filename)}"
            expect(response.headers['Content-Transfer-Encoding']).to eq 'binary'
          end

          it "should return the partial file" do
            get :stream, filename: @filename
            expect(response.body).to eq File.open(@filename){|f| f.read(4)}
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
                  get :stream, filename: @filename
                  expect(response.status).to eq 416
                end

                it "should return a file" do
                  get :stream, filename: @filename
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
