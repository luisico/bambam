var tour_project_show_manager = {
  id: "tour-project-show-manager",
  showPrevButton: true,
  steps: [
    {
      title: "Tour: Project page",
      content: "Name of project and project owner. Click on project name to edit. Unique and memorable names work best.<br/><br/>Click <i class='fi-x small-margin-left margin-right text-color-grey'></i> to exit tour at any time.",
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
      content: "Individuals with access to the project.<br/><br/>By default, users can add tracks and remove tracks they have created. They cannot add/remove directories.<br/><br/>Restrict user access by clicking<br/>'set read-only' below their name.",
      target: "#regular-users",
      placement: 'right'
    },
    {
      title: "Read-Only Users",
      content: "These users can view project files but cannot add/delete tracks. Restore user access by clicking 'restore access' below their name.",
      target: "#read-only-users",
      placement: 'right'
    },
    {
      title: "Edit Users",
      content: "Click here to add/remove users from project.",
      target: "#edit-users",
      placement: 'bottom',
      multipage: true,
      nextOnTargetClick: true,
      showNextButton: false,
      showCTAButton: true,
      ctaLabel: "Skip",
      onCTA: function() {
        hopscotch.showStep(hopscotch.getCurrStepNum() + 2);
      }
    },
    {
      title: "Add/remove users",
      content: "Click 'x' next to user name to remove user from project. Type into box to search for and add new user.",
      target: ".select2-choices",
      placement: 'bottom',
      multipage: true,
      onPrev: function() {
        $('#cancel-edit-users').click();
        hopscotch.showStep(4);
      },
      onNext: function() {
        $('#cancel-edit-users').click();
        hopscotch.showStep(6);
      }
    },
    {
      title: "Project datapaths and tracks",
      content: "List of datapaths and tracks associated with the project.",
      target: ".project-datapaths",
      placement: 'top',
      onPrev: function() {
        hopscotch.showStep(4)
      }
    },
    {
      title: "Add or remove directories/tracks from project",
      content: "Select/deselect a checkbox to add/remove a directory/track from the project.<br/><br/>Tracks are only available to add if one of their parent directories has been selected.<br/><br/>There can be only one selected directory within a given file path.",
      target: ".fancytree-folder",
      placement: 'top'
    },
    {
      title: "Tracks",
      content: "Each project track displays a link to view more information on the track, reference genome, and a button to open the track in IGV.",
      target: ".track-link",
      placement: 'top'
    }
  ]
};
