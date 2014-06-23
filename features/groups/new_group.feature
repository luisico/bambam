Feature: Create a group
  In order to add a new group to the application
  As an admin
  I want to be able to access a page where I can add a new group

  Background:
    Given I am signed in as an admin
    And there are 3 other users in the system

  Scenario: Admin creates a new group (and they become a member)
    When I am on the groups page
    And I follow the new group link
    Then I should be on the new group page
    And my checkbox should be disabled

    When I create a new group
    Then I should be on the group show page
    And I should see a message that the group was created successfully
    And I should see my email among the list of group member emails
    And I should be the groups owner

  Scenario: Cannot create a group without a name
    Given I am on the new group page
    When I create a group without a name
    Then the "Group name" field should have the error "can't be blank"
    And I should be on the new group page

  Scenario: Can add more than one user to a group
    Given I am on the new group page
    When I create a group with multiple members
    Then I should be on the group show page
    And all the group member email addresses on the list
    And I should see a message that the group was created successfully

  Scenario: User cannot create a group
    Given I sign out
    And I am signed in as a user
    When I am on the groups page
    Then I should not see link to create a new group
