@javascript
Feature: Edit project description
  In order to have an up to date project
  As a manager
  I can update a project description

  Scenario Outline: Edit project description
    Given I am signed in as <role>
    And <project exists>
    And there are 3 additional users of that project
    And there are 3 datapaths in that project
    When I am on the project page
    Then I <privilege> be able to edit the project description

    Examples:
      | role      | project exists        | privilege  |
      | a manager | I own a project       | should     |
      | a user    | I belong to a project | should not |

  Scenario: Manager allowed to set project description to blank
    Given I am signed in as a manager
    And I own a project
    And there are 3 additional users of that project
    And there are 3 datapaths in that project
    When I am on the project page
    Then I should be able to set project description to blank
