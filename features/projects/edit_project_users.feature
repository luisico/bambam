@javascript
Feature: Edit project users
  In order to have an up to date project
  As a manager/admin
  I can update project users
  @now
  Scenario Outline: Admin and managers can change users in project
    Given I am signed in as <role>
    And <project exists>
    And there are 3 additional users of that project
    And there are 3 other users in the system
    When I am on the project page
    Then I <privilege> be able to change users in the project

    Examples:
      | role      | project exists                   | privilege  |
      | an admin  | there is a project in the system | should     |
      | a manager | I own a project                  | should     |
      | a user    | I belong to a project            | should not |

  Scenario: Cancel out of edit project user form
    Given I am signed in as a manager
    And I own a project
    When I am on the project page
    Then I should be able to cancel out of the edit project user form
