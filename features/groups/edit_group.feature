Feature: Edit group information
  In order to have an up to date group
  As a admin
  I can update my group' info

  Background:
    Given I am signed in as an admin
    And I own a group
    And there are 3 additional members of that group

  Scenario: Admin can access the group edit page from the group show page
    When I am on the group page
    And I click on the group edit link
    Then I should be on the edit group page

  Scenario: Admin can change the group name
    When I visit the edit group page
    Then I should be able to edit the group name

  @javascript
  Scenario: Admin can change the group members
    When I visit the edit group page
    Then I should be able to edit the group members

  Scenario: Canceling the update brings back to the users page
    When I visit the edit group page
    And I click "Cancel"
    Then I should be on the users page
