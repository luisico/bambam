var tour_user_index = {
  id: "tour-user-index",
  showPrevButton: true,
  steps: [
    {
      title: "Tour: Users page",
      content: "Invite new users, see list of existing users and create groups.<br/><br/>Click <i class='tour-close'></i> to exit tour at any time.",
      target: "#invite-user",
      placement: 'right'
    },
    {
      title: "Invite new users",
      content: "Invite new users by entering their email address",
      target: "#invite-user",
      placement: 'right',
      arrowOffset: 'center'
    },
    {
      title: "Add invitee to existing projects",
      content: "Type in name of project or select from dropdown menu. Add as many projects as you want.",
      target: "#s2id_project_ids",
      placement: 'top'
    },
    {
      title: "Send invitation",
      content: "Click button to send invitation. Invitee will be added to projects you selected.",
      target: "#invite-email",
      placement: 'bottom'
    },
    {
      title: "System users",
      content: "List of all the current users, including those that have been invited but not yet registered.",
      target: "#current-users",
      placement: 'top'
    },
    {
      title: "System users",
      content: "Each user entry has link to their profile page and information on status (invite outstanding <i class='invite-icon icon-tour'></i>, admin <i class='admin-icon icon-tour'></i>, etc.).",
      target: ".current-user",
      placement: 'top'
    },
    {
      title: "Groups",
      content: "List of the current groups along with button to create new group.",
      target: "#groups-headline",
      placement: 'bottom'
    },
    {
      title: "Group",
      content: "Groups are designed for organizing groups of people. This feature is currently a work in progress.",
      target: "#group-list",
      placement: 'bottom'
    }
  ]
};
