Feature: List of projects
  In order to manage projects
  As a user
  I should be able to list projects

  Scenario: Admin can view list of all projects
    Given I am signed in as an admin
    And there are 10 projects in the system
    When I am on the projects page
    Then I should see a list of projects

  Scenario: Users can view list of their projects
    Given I am signed in
    And one of my projects is in the system
    And there are 10 projects in the system
    When I am on the projects page
    Then I should only see a list of my projects

  Scenario: User can see list of tracks on projects page
    Given I am signed in
    And one of my projects is in the system
    And there are 10 tracks in the system
    When I am on the projects page
    Then I should see a list of tracks
    And I should see a "New Track" button
