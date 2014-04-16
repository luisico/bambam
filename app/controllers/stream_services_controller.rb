class StreamServicesController < ApplicationController
  def show
    begin
      track = Track.find(params[:id])
      path = track.path
      path << ".#{params[:format]}" if params[:format]

      if File.size?(path)
        if request.head?
          response.header["Content-Length"] = File.size(path)
          render nothing: true, status: :ok
        else
          opts = {filename: path, disposition: 'inline', type: 'text/plain'}

          if request.headers["HTTP_RANGE"]
            # Send requested range. Only first range is proccessed
            size = File.size(path)
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

              send_data IO.binread(path, length, bytes.begin), opts.merge(status: 206)
            end
          else
            send_file path, opts
          end
        end
      else
        render nothing: true, status: :not_found
      end
    rescue ActiveRecord::RecordNotFound
      render nothing: true, status: :not_found
    end
  end
end
