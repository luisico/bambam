Feature: Edit group information
  In order to have an up to date group
  As a user
  I can update group name and members

  Background:
    Given I am signed in
    And there is a group in the system
    And there are 3 members of that group

  Scenario: User can access the group edit page from the group show page
    When I am on the group page
    And I click on the group edit link
    Then I should be on the edit group page

  Scenario: User can change the group name
    When I visit the edit group page
    Then I should be able to edit the group name

  Scenario: User can change the group members
    When I visit the edit group page
    Then I should be able to edit the group members

