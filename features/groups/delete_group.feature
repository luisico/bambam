Feature: Delete a group
  In order to remove a group from the system
  As a admin
  I can delete a group

  Scenario Outline: Delete a group
    Given I am signed in as <role>
    And <group exists>
    When I am on the group page
    Then I should be able to delete a group

    Examples:
    | role      | group exists                   |
    | an admin  | there is a group in the system |
    | a manager | I own a group                  |
