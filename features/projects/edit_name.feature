@javascript
Feature: Edit project name
  In order to have an up to date project
  As a user/admin
  I can update project name

  Scenario Outline: Edit project name
    Given I am signed in as <role>
    And <project exists>
    And there are 3 additional users of that project
    And there are 3 datapaths in that project
    When I am on the project page
    Then I <privilege> be able to edit the project name

    Examples:
      | role      | project exists        | privilege  |
      | a manager | I own a project       | should     |
      | a user    | I belong to a project | should not |

  Scenario: Manager not allowed to set project name to blank
    Given I am signed in as a manager
    And I own a project
    And there are 3 additional users of that project
    And there are 3 datapaths in that project
    When I am on the project page
    Then I should not be able to set project name to blank
