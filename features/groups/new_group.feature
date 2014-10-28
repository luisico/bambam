Feature: Create a group
  In order to add a new group to the application
  As an admin
  I want to be able to access a page where I can add a new group

  Background:
    Given I am signed in as an admin
    And there are 3 other users in the system

  @javascript
  Scenario: Admin goes to new group page
    When I am on the users page
    And I follow the new group link
    Then I should be on the new group page
    And my name should be listed as group owner
    And I should see a list of potential members

  @javascript
  Scenario: Admin creates a new group (and they become a member)
    Given I am on the new group page
    When I create a new group
    Then I should be on the group show page
    And I should see a message that the group was created successfully
    And I should see my email among the list of group member emails
    And I should be the groups owner

  @javascript
  Scenario: Cannot create a group without a name
    Given I am on the new group page
    When I create a group without a name
    Then the "Group name" field should have the error "can't be blank"
    And I should be on the new group page

  @javascript
  Scenario: Can add more than one user to a group
    Given I am on the new group page
    When I create a group with multiple members
    Then I should be on the group show page
    And all the group member email addresses on the list
    And I should see a message that the group was created successfully

  Scenario: Canceling the new group brings back to the users page
    When I am on the new group page
    And I click "Cancel"
    Then I should be on the users page
