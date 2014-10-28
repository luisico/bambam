Feature: Edit other group's information
  In order to have an up to date group
  As a admin
  I can update group's info that I don't own

  Background:
    Given I am signed in as an admin
    And there is a group in the system
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

  Scenario: Admin can update group without changing group owner
    When I visit the edit group page
    Then I should be able to update group without changing group owner

  @javascript
  Scenario: Admin can add itself to group
    When I visit the edit group page
    Then I should be able to add myself to the group
