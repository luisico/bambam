Feature: Delete a project
  In order to remove a project from the system
  As an admin
  I can delete a project

  Scenario: Admin can delete a project they own
    Given I am signed in as an admin
    And I own a project
    When I am on the project page
    Then I should be able to delete the project

  Scenario: Admin can delete any project
    Given I am signed in as an admin
    And there is a project in the system
    When I am on the project page
    Then I should be able to delete the project