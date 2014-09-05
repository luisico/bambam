var tour_project_new = {
  id: "tour-project-new",
  showPrevButton: true,
  steps: [
    {
      title: "Tour: Making a new project",
      content: "Get started on making a new project.<br/><br/>Click 'x' to exit tour at any time.",
      target: "#new-project-headline",
      placement: 'bottom'
    },
    {
      title: "Pick name for the project",
      content: "Unique and memorable names work best.",
      target: "#project_name",
      placement: 'bottom'
    },
    {
      title: "Assign users to the project",
      content: "Check box next to email of each person you want in your project. Users on a project can add, edit, and share tracks.",
      target: "#project-users",
      placement: 'top'
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
      title: "Click here to create project",
      content: "This will create the project and any tracks that have been added in the process.",
      target: ".update-project-tracks",
      placement: 'top'
    }
  ]
};
