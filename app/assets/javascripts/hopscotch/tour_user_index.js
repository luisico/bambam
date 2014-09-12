var tour_user_index = {
  id: "tour-user-index",
  showPrevButton: true,
  steps: [
    {
      title: "Tour: Users page",
      content: "Invite new users and see existing users and groups.<br/><br/>Click 'x' to exit tour at any time.",
      target: "#invite-user",
      placement: 'right'
    },
    {
      title: "Invitation form",
      content: "Enter an email and click send to invite new users to the system.",
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
      content: "Each user entry has link to their profile page and information on status (invite outstanding <i class='fi-ticket'></i>, admin <i class='fi-crown'></i>, etc.).",
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
