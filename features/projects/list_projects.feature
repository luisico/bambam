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
    And I own a project
    And there are 10 projects in the system
    When I am on the projects page
    Then I should only see a list of my projects
