module TracksHelper
  def link_to_igv(track, text=nil)
    klass = 'tiny radius service button'
    if text.nil?
      text = 'igv'
      klass << ' fi-eye'
    end

    link_to text, igv_url(track), class: klass
  end

  def igv_url(track)
    format = File.extname(track.path).slice(1..-1)
    url = URI::Generic.build(
      scheme: 'http', host: 'localhost', port: 60151,
      path: '/load',
      query: {
        file: stream_services_track_url(track, format: format),
        genome: 'hg19',
        name: track.name,
        merge: true
      }.to_query
    ).to_s
  end

  def ucsc_track_line(share_link)
    types = {'.bam' => 'bam', '.bw' => 'bigWig'}

    track_line = {
      'type'       => types[Pathname.new(share_link.track.path).extname],
      'name'       => share_link.track.name.blank? ? nil : "\"#{share_link.track.name}\"",
      'bigDataUrl' => ucsc_url(share_link)
    }

    'track ' << track_line.map{|k,v| "#{k}=#{v}" unless v.blank?}.join(' ')
  end

  def ucsc_url(share_link)
    url = stream_services_track_url(share_link.track)
    url.to_s + "?access_token=#{share_link.access_token}"
  end
end
