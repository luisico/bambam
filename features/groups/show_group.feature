Feature: Show a group
  In order to see the information about a group
  As a user
  I want to be able to access a page with all the information about a group

  Scenario: User can access the group show page from the groups page
    Given I am signed in
    And there is a group in the system
    And there are 3 additional members of that group
    When I am on the groups page
    And I click on the group name
    Then I should be on the show group page

  Scenario: Show a group's information
    Given I am signed in
    And there is a group in the system
    And there are 3 additional members of that group
    When I am on the group page
    Then I should see the group's name
    And I should see the group's members
    And I should see the group's creation date
    And I should see the date of the group's last update
    And I should not see a "Delete" button
    And I should not see an "Edit" button

  Scenario Outline: Admin/inviter can access group page from users page
    Given I am signed in as an <role>
    And there are 3 groups in the system
    When I am on the users page
    And I click on the group name
    Then I should be on the show group page

    Examples:
      | role    |
      | admin   |
      | inviter |
