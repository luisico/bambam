jQuery ->
  div = $('#track-igv')[0]
  options =
    showNavigation: true
    genome: 'hg19'
    locus: 'chr1:155,172,193-155,172,564'
    tracks: [ {
      url: '//www.broadinstitute.org/igvdata/1KG/b37/data/NA06984/alignment/NA06984.mapped.ILLUMINA.bwa.CEU.low_coverage.20120522.bam'
      label: 'NA06984'
    } ]
  igv.createBrowser div, options
  return
