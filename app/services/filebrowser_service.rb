class FilebrowserService
  FORMATS = Track::FILE_FORMATS.collect{|k,v| v[:extension]}

  attr_reader :path

  def initialize(path)
    @path = path
  end

  def call
    Dir.chdir(path) do
      globs = ["*/"].concat(FORMATS.map{ |f| "*.#{f}" })
      @entries = Dir.glob(globs)
    end

    entries
  end

  def to_fancytree
    fancytree = []

    entries(path).each do |entry|
      if m = entry.match(/(.*)\/$/)
        # Directories
        node = {title: m[1]}
        node.merge!(folder: true, lazy: true)
      else
        # Files
        node = {title: entry}
      end

      fancytree << node
    end

    fancytree
  end

  def entries(path=@path)
    # Argument not needed, but helps in testing
    @entries || call
  end
end
