Feature: List of users
  In order to manage users
  As an admin user
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
    | inviter |

  Scenario: Only admins and inviters can access the users page
    Given I am signed in
    And there is not a users link in the navigation bar
    When I visit the users page
    Then I should be denied access
    And I should be redirected to the tracks page
