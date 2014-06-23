Feature: Delete a group
  In order to remove a group from the system
  As a admin
  I can delete a group

  Scenario: Delete a group
    Given I am signed in as an admin
    Given I own a group
    When I am on the group page
    Then I should be able to delete a group
