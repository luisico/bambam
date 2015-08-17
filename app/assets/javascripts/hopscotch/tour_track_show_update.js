var tour_track_show_update = {
  id: "tour-track-show-update",
  showPrevButton: true,
  steps: [
    {
      title: "Tour: Track page",
      content: "View detailed information on track and share links.<br/><br/>Click <i class='tour-close'></i> to exit tour at any time.",
      target: ".track-name",
      placement: 'right'
    },
    {
      title: "Track name",
      content: "Click on name of track to edit.",
      target: ".track-name",
      placement: 'bottom'
    },
    {
      title: "Reference genome",
      content: "Click on reference genome to edit.",
      target: ".genome",
      placement: 'bottom'
    },
    {
      title: "Timestamps",
      content: "Track creation date <i class='created-at-icon icon-tour'></i> and date of last update <i class='updated-at-icon icon-tour'></i>.",
      target: "#timestamps",
      placement: 'left'
    },
    {
      title: "IGV",
      content: "Click to open track in IGV. For link to work, IGV must already be open on your computer.",
      target: ".fi-eye",
      placement: 'bottom'
    },
    {
      title: "Track download links",
      content: "Click links to download track file(s).",
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
      onShow: function() {
        var ary_length = $('#new_share_link').length
        if (ary_length == 1) {
          hopscotch.showStep(hopscotch.getCurrStepNum() + 1);
        }
      },
      onCTA: function() {
        hopscotch.showStep(hopscotch.getCurrStepNum() + 2);
      }
    },
    {
      title: "New share link form",
      content: "Set expiration date using pop up calendar or one of the blue shortcut links. Notes are optional, but could be useful for tracking where and with whom links have been shared.",
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
      content: "List of existing share links. View and copy links, edit expiration date and notes, or delete share link.",
      target: "#share-links-list",
      placement: 'top',
      arrowOffset: 'center'
    }
  ]
};
