Feature: List of users
  In order to manage users
  As an manager
  I should be able to list users

  Scenario: Users index page
    Given I am signed in as an manager
    And there is a users link in the navigation bar
    When I visit the users page
    Then I should see a list of users
    And I should see their avatars
    And my manager email should not have outstanding invite icon
    And I should see a form to invite a new user

  Scenario: Admin can see all groups
    Given I am signed in as an admin
    And I own a group
    And I belong to 3 groups
    And there are 3 groups in the system
    When I visit the users page
    Then I should see a list of all groups

  Scenario: Manager can only see groups they own or are a member of
    Given I am signed in as a manager
    And I own a group
    And I belong to 3 groups
    And there are 3 groups in the system
    When I visit the users page
    And I should only see a list of groups I own or am a member of

  Scenario: Manager can click through to group show page
    Given I am signed in as a manager
    And I own a group
    And I belong to 3 groups
    When I visit the users page

    When I click on the group name
    Then I should be on the show group page

  Scenario: Manager can access users page from navigation bar
    Given I am signed in as an manager
    When I click on "Users" in the top nav
    Then I should be on the users page

  Scenario: User cannot access the users page from navigation bar
    Given I am signed in
    And there is not a users link in the navigation bar
    When I visit the users page
    Then I should be denied access
    And I should be redirected to the projects page
