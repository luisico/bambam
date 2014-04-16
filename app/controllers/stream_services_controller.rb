class StreamServicesController < ApplicationController
  def show
    begin
      track = Track.find(params[:id])
      path = track.path
      path << ".#{params[:format]}" if params[:format]

      raise Errno::ENOENT unless File.size?(path)

      if request.head?
        response.header["Content-Length"] = File.size(path)
        render nothing: true, status: :ok
      else
        opts = {filename: path, disposition: 'inline', type: 'text/plain'}
        if request.headers["HTTP_RANGE"]
          respond_with_range(opts)
        else
          send_file path, opts
        end
      end

    rescue ActiveRecord::RecordNotFound, Errno::ENOENT
      render nothing: true, status: :not_found
    rescue RangeError
      render nothing: true, status: 416
    end
  end

  private

  # Send requested range
  # Only first range is proccessed
  def respond_with_range(opts)
    path = opts[:filename]
    size = File.size(path)

    ranges = Rack::Utils.byte_ranges(request.headers, size)
    raise RangeError if ranges.nil? || ranges.empty?

    bytes = ranges[0]
    length = (bytes.end - bytes.begin) + 1

    response.header.merge!({
      "Accept-Ranges" => "bytes",
      "Content-Range" => "bytes #{bytes.begin}-#{bytes.end}/#{size}",
      "Content-Length" => length
    })
    opts.merge!(status: 206)

    send_data IO.binread(path, length, bytes.begin), opts
  end
end
