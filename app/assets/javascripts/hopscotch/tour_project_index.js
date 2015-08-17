var tour_project_index = {
  id: "tour-project-index",
  showPrevButton: true,
  steps: [
    {
      title: "Tour: Project index page",
      content: "List of all the projects and their summary information.<br/><br/>Click <i class='tour-close'></i> to exit tour at any time.",
      target: ".project-tile",
      placement: "right"
    },
    {
      title: "Project index page",
      content: "Each tile contains a link to the project page, track count <i class='track-icon icon-tour'></i>, user count <i class='users-icon icon-tour'></i>, project owner <i class='owner-icon icon-tour'></i> and date of last update <i class='updated-at-icon icon-tour'></i>.",
      target: ".project-tile",
      placement: "right",
      arrowOffset: "center"
    }
  ]
};
