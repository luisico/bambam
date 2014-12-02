var tour_project_show = {
  id: "tour-project-show",
  showPrevButton: true,
  steps: [
    {
      title: "Tour: Project page",
      content: "Name of project.<br/><br/>Click <i class='fi-x small-margin-left margin-right text-color-grey'></i> to exit tour at any time.",
      target: "#project-name",
      placement: 'bottom'
    },
    {
      title: "Timestamps",
      content: "Project creation date <i class='fi-calendar'></i> and date of last update <i class='fi-clock'></i>.",
      target: "#timestamps",
      placement: 'left'
    },
    {
      title: "Users",
      content: "Individuals with access to the project. Project owner indicated by sherrif's badge.",
      target: "#regular-users",
      placement: 'top'
    },
    {
      title: "Track list",
      content: "All tracks in the project.",
      target: "#project-tracks",
      placement: 'top'
    },
    {
      title: "View all of your tracks",
      content: "Link to all tracks you can access, irrespective of project.",
      target: "#all-user-tracks",
      placement: 'top'
    },
    {
      title: "Tracks",
      content: "Button to open the track in IGV and link to view more information on track.",
      target: "#project-tracks-list",
      placement: 'top'
    }
  ]
};
