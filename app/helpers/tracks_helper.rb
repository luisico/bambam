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
    url = URI::Generic.build(
      scheme: 'http', host: 'localhost', port: 60151,
      path: '/load',
      query: {
        file: stream_services_track_url(track),
        genome: 'hg19',
        name: track.name,
        merge: true
      }.to_query
  ).to_s
  end
end

