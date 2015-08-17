var tour_project_show = {
  id: "tour-project-show",
  showPrevButton: true,
  steps: [
    {
      title: "Tour: Project page",
      content: "Displays specific information about the project.<br/><br/>Click <i class='tour-close'></i> to exit tour at any time.",
      target: "#project-name",
      placement: 'right'
    },
    {
      title: "Project name and owner",
      content: "Name of project and project owner. Click on project name to edit. Unique and memorable names work best.<br/><br/>Click <i class='tour-close'></i> to exit tour at any time.",
      target: "#project-name",
      placement: 'bottom'
    },
    {
      title: "Timestamps",
      content: "Project creation date <i class='created-at-icon icon-tour'></i> and date of last update <i class='updated-at-icon icon-tour'></i>.",
      target: "#timestamps",
      placement: 'left'
    },
    {
      title: "Users",
      content: "Individuals with access to the project.",
      target: "#regular-users",
      placement: 'top'
    },
    {
      title: "Read-Only Users",
      content: "Individuals with read only access to the project.",
      target: "#read-only-users",
      placement: 'top'
    },
    {
      title: "Project tracks",
      content: "List of tracks associated with the project.",
      target: ".project-datapaths",
      placement: 'top'
    },
    {
      title: "Tracks",
      content: "Each project track displays a link to view more information on the track, reference genome, and a button to open the track in IGV.",
      target: ".track-link",
      placement: 'top'
    },
    {
      title: "Add or remove tracks from project",
      content: "Select/deselect a checkbox to add/remove track from the project.<br/><br/>Tracks are only available to add if one of their parent directories has been selected.<br/><br/>If you don't see a file that you'd like to add to the project, request that a project manager add one of its parent directories to the project.",
      target: ".fancytree-checkbox",
      placement: 'top'
    }
  ]
};
