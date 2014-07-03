Feature: List of projects
  In order to manage projects
  As a user
  I should be able to list projects

  Scenario: User can access projects page from top navbar
    Given I am signed in
    And I belong to 3 projects
    When I click on "Projects" in the top nav
    Then I should be on the projects page

  Scenario: Users can view list of only their projects
    Given I am signed in
    And I belong to 3 projects
    And there are 10 projects in the system
    When I am on the projects page
    Then I should only see a list of my projects

  Scenario: Admin can view list of all projects
    Given I am signed in as an admin
    And there are 10 projects in the system
    When I am on the projects page
    Then I should see a list of projects
