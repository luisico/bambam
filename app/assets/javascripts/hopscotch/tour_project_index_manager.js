var tour_project_index_manager = {
  id: "tour-project-index-manager",
  showPrevButton: true,
  steps: [
    {
      title: "Tour: Project index page",
      content: "List of all the projects and their summary information.<br/><br/>Click <i class='fi-x small-margin-left margin-right text-color-grey'></i> to exit tour at any time.",
      target: ".project-tile",
      placement: "right"
    },
    {
      title: "Project index page",
      content: "Each tile contains a link to the project page, track count <i class='track-icon small-margin-left'></i>, user count <i class='users-icon small-margin-left'></i>, project owner <i class='admin-icon small-margin-left'></i> and date of last update <i class='fi-clock small-margin-left'></i>.",
      target: ".project-tile",
      placement: "right",
      arrowOffset: "center"
    },
    {
      title: "New project button",
      content: "Click here to create a new project",
      target: "#new-project",
      placement: "bottom",
      ctaLabel: "Done",
      showCTAButton: true,
      showNextButton: false,
      nextOnTargetClick: true,
      multipage: true,
      onCTA: function() {
        hopscotch.endTour();
      }
    },
    {
      title: "Create new project",
      content: "Enter project name and click here to create a new project",
      target: '#create-project',
      placement: "bottom",
      ctaLabel: "Done",
      showCTAButton: true,
      showNextButton: false,
      nextOnTargetClick: true,
      onCTA: function() {
        hopscotch.endTour();
        $('#project-cancel').click();
      },
      onNext: function() {
        hopscotch.endTour();
      },
      onPrev: function() {
        $('#project-cancel').click();
        hopscotch.showStep(2);
      },
    }
  ]
};

