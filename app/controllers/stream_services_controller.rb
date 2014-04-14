class StreamServicesController < ApplicationController
  def stream
    # puts request.env.select{|e| e =~ /^(X-|HTTP_)/}
    # track = "/#{params[:filename]}.#{params[:format]}"

    track = params[:filename]

    # dirname = File.dirname(track)
    # basename = File.basename(track, ".bai")
    # filename = File.join(dirname, basename)

    if File.exist?(track) # and Track.exists?(filename: filename)
      if request.head?
        response.header["Content-Length"] = File.size(track)
        render nothing: true, status: :ok
      else
        opts = {filename: track, disposition: 'inline', type: 'text/plain'}
        if request.headers["HTTP_RANGE"]
          # Send requested range. Only first range is proccessed
          size = File.size(track)
          ranges = Rack::Utils.byte_ranges(request.headers, size)

          if ranges.nil? || ranges.empty?
            render nothing: true, status: 416
          else
            bytes = ranges[0]
            length = (bytes.end - bytes.begin) + 1

            response.header.merge!({
              "Accept-Ranges" => "bytes",
              "Content-Range" => "bytes #{bytes.begin}-#{bytes.end}/#{size}",
              "Content-Length" => length
            })

            send_data IO.binread(track, length, bytes.begin), opts.merge(status: 206)
          end
        else
          send_file track, opts
        end
      end
    else
      render nothing: true, status: :not_found
    end
  end
end
