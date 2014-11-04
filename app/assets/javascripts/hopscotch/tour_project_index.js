var tour_project_index = {
  id: "tour-project-index",
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
    }
  ]
};
