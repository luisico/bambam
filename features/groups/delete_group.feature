Feature: Delete a group
  In order to remove a group from the system
  As a admin
  I can delete a group

  Scenario: User can access the group edit page from the groups page
    Given I am signed in as an admin
    Given I own a group
    When I am on the group page
    Then I should be able to delete a group
