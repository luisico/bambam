var tour_track_show = {
  id: "tour-track-show",
  showPrevButton: true,
  steps: [
    {
      title: "Tour: Track page",
      content: "Info about a track, starting with name and associated project.<br/><br/>Click 'x' to exit tour at any time.",
      target: "#track-name",
      placement: 'bottom'
    },
    {
      title: "Timestamps",
      content: "Track creation date <i class='fi-calendar'></i> and date of last update <i class='fi-clock'></i>.",
      target: "#track-timestamps",
      placement: 'left'
    },
    {
      title: "IGV and download links",
      content: "Click to open track in IVG or download track file(s).",
      target: "#track-download-links",
      placement: 'bottom',
      arrowOffset: 'center'
    },
    {
      title: "Server path",
      content: "Path of track on server. Click clipboard icon to copy server path to clipboard.",
      target: "#track-server-path",
      placement: 'bottom'
    },
    {
      title: "Share links",
      content: "Share tracks with the outside world.",
      target: "#track-share-links",
      placement: 'top'
    },
    {
      title: "Create new share link",
      content: "Try it yourself!<br/>Click 'Create new share link'",
      target: "#new_link",
      placement: 'bottom',
      ctaLabel: "Skip",
      showCTAButton: true,
      showNextButton: false,
      nextOnTargetClick: true,
      onCTA: function() {
        hopscotch.showStep(hopscotch.getCurrStepNum() + 2);
      }
    },
    {
      title: "New share link form",
      content: "Set expiration date using pop up calendar or one of the blue short links. Notes are optional, but could be useful for tracking where links have been shared.",
      target: "#new_share_link",
      placement: 'top',
      arrowOffset: 'center',
      delay: 500,
      onPrev: function() {
        $('#new_share_link').remove();
        $('#new_link').show();
      },
      onNext: function() {
        $('#new_share_link').remove();
        $('#new_link').show();
      }
    },
    {
      title: "Share links",
      content: "List of existing share links. Click to view and copy links, edit expiration date and notes or delete share link.",
      target: "#share-links",
      placement: 'top',
      arrowOffset: 'center'
    }
  ]
};
