var tour_admin_project_show = {
  id: "tour-admin-project-show",
  showPrevButton: true,
  steps: [
    {
      title: "Tour: Project page",
      content: "Info about the project starting with name.<br/><br/>Click 'x' to exit tour at any time.",
      target: "#project-name",
      placement: 'bottom'
    },
    {
      title: "Timestamps",
      content: "Project creation date and date of last update.",
      target: "#project-timestamps",
      placement: 'left'
    },
    {
      title: "Users",
      content: "Individuals with access to the project. Project owner indicated by sherrif badge.",
      target: "#project-users",
      placement: 'top'
    },
    {
      title: "Track list",
      content: "All tracks in the project. Also, link to all tracks you can access.",
      target: "#project-tracks",
      placement: 'top'
    },
    {
      title: "Tracks",
      content: "Button to open each track in IGV and link to view more information on track.",
      target: "#project-tracks-list",
      placement: 'top'
    }
  ]
};
