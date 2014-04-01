Feature: List of users
  In order to manage users
  As an admin user
  I should be able to list users

  Scenario: List of users
    Given I am signed in as an admin
    When I visit the users page
    Then I should see a list of users
    And I should see a link to invite new users

  Scenario: Only admin users can access the users page
    Given I am signed in
    When I visit the users page
    Then I should be denied access
    And I should be redirected to the home page
