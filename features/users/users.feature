Feature: List of users
  In order to manage users
  As an admin
  I should be able to list users

  Scenario Outline: List of users
    Given I am signed in as an <role>
    And there is a users link in the navigation bar
    When I visit the users page
    Then I should see a list of users
    And I should see their avatars
    And my <role> email should not have outstanding invite icon
    And I should see a form to invite a new user

  Examples:
    | role    |
    | admin   |
    | manager |

  Scenario: List of groups
    Given I am signed in as an admin
    And there are 3 groups in the system
    When I visit the users page
    And I should see a list of all groups

    When I click on the group name
    Then I should be on the show group page

  Scenario: Admin can access users page from navigation bar
    Given I am signed in as an admin
    When I click on "Users" in the top nav
    Then I should be on the users page

  Scenario: User cannot access the users page from navigation bar
    Given I am signed in
    And there is not a users link in the navigation bar
    When I visit the users page
    Then I should be denied access
    And I should be redirected to the projects page
