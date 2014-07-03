Feature: Delete a project
  In order to remove a project from the system
  As a user
  I can delete a project

  Scenario: Admin can delete a project
    Given I am signed in as an admin
    And I own a project
    When I am on the project page
    Then I should be able to delete a project
