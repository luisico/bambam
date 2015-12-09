module LocusService
  def locus_for(user, object)
    type = object.class.to_s
    Locus.find_by(locusable_id: object.id, locusable_type: type, user: user) ||
      Locus.create(locusable_id: object.id, locusable_type: type, user: user, range: '0')
  end
end
