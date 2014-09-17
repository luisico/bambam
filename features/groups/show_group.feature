Feature: Show a group
  In order to see the information about a group
  As a user
  I want to be able to access a page with all the information about a group

  Scenario: Show a group's information
    Given I am signed in
    And I belong to a group
    And there are 3 additional members of that group
    When I am on the group page
    Then I should see the group's name
    And I should see the group's owner
    And I should see the group's members
    And I should see the group's timestamps

  Scenario: Show member links for admins
    Given I am signed in as an admin
    And there is a group in the system
    And there are 3 additional members of that group
    When I am on the group page
    And I should see the group's members with links

  Scenario Outline: Edit and delete buttons
    Given I am signed in as <role>
    And <group exists>
    And there is a group in the system
    When I am on the group page
    And I <visible> see a "Delete" button
    And I <visible> see an "Edit" button

    Examples:
     | role     | visible    | group exists                   |
     | an admin | should     | there is a group in the system |
     | an admin | should     | I own a group                  |
     | a user   | should not | I belong to a group            |

  Scenario Outline: Back button
    Given I am signed in as <role>
    And <group exists>
    When I am on the <source> page
    And I click on the group name
    And I click "Back"
    Then I should be on the <source> page

    Examples:
     | role     | group exists                   | source          |
     | an admin | there is a group in the system | users           |
     | a user   | I belong to a group            | account profile |
