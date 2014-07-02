Feature: Delate a project
  In order to remove a project from the system
  As a user
  I can delete a project

  Scenario: Admin can access the project edit page from the projects page
    Given I am signed in as an admin
    And I own a project
    When I am on the project page
    Then I should be able to delete a project

  Scenario: User cannot delete project
    Given I am signed in as a user
    And I belong to a project
    When I am on the project page
    Then I should not be able to delete a project
