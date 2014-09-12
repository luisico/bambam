var tour_project_edit = {
  id: "tour-project-edit",
  showPrevButton: true,
  steps: [
    {
      title: "Tour: Edit an existing track",
      content: "Try it yourself!<br/>Click track name to edit track or trash can to delete track.<br/><br/>Click 'x' to exit tour at any time.",
      target: ".track-name",
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
      title: "Edit track form",
      content: "Edit track name or path.",
      target: ".edit-record",
      placement: 'top',
      delay: 500,
      onPrev: function() {
        $('.done-track').click();
      },
      onNext: function() {
        $('.done-track').click();
      }
    },
    {
      title: "Add tracks to your project",
      content: "Try it yourself!<br/>Click link above to add a track to the project.",
      target: ".add_fields",
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
      title: "New track form",
      content: "Track path must begin with one of the supplied top directories. Also note that tracks are not added or updated until the project is saved.",
      target: ".new-record",
      placement: 'top',
      delay: 500,
      onPrev: function() {
        $('.new-record').remove();
      },
      onNext: function() {
        $('.new-record').remove();
      }
    },
    {
      title: "Click here to update project",
      content: "This will create the project and any tracks that have been edited and added in the process.",
      target: ".update-project-tracks",
      placement: 'top'
    }
  ]
};
