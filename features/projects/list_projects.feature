Feature: List of projects
  In order to manage projects
  As a user
  I should be able to list projects

  Scenario: User can access projects page from top navbar
    Given I am signed in
    When I click on "Projects" in the top nav
    Then I should be on the projects page

  Scenario: Users can only view list of projects they belong to
    Given I am signed in
    And I belong to 3 projects
    And there are 3 projects in the system
    When I am on the projects page
    Then I should only see a list of projects I belong to

  Scenario: Admin can view list of all projects
    Given I am signed in as an admin
    And there are 3 projects in the system
    When I am on the projects page
    Then I should see a list of all projects

  Scenario: User can access the project show page
    Given I am signed in
    And I belong to a project
    When I am on the projects page
    And I click on the project name
    Then I should be on the project page

  Scenario: Admin can access the new project page
    Given I am signed in as an admin
    When I am on the projects page
    And I click "New Project"
    Then I should be on the new project page

  Scenario: User cannot access the new project page
    Given I am signed in as a user
    When I am on the projects page
    Then I should not see a link to "New Project"
