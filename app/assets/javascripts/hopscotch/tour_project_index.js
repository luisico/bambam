var tour_project_index = {
  id: "tour-project-index",
  showPrevButton: true,
  steps: [
    {
      title: "Tour: Project index page",
      content: "List of all the projects and their summary information.<br/><br/>Click 'x' to exit tour at any time.",
      target: ".project-tile",
      placement: "right"
    },
    {
      title: "Project index page",
      content: "Each tile contains a link to the project page, track count <i class='fi-paw'></i>, user count <i class='fi-torsos'></i>, project owner <i class='fi-sheriff-badge'></i> and date of last update <i class='fi-clock'></i>.",
      target: ".project-tile",
      placement: "right",
      arrowOffset: "center"
    }
  ]
};
