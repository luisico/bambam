@javascript
Feature: Edit projects datapaths
  In order to have an up to date project
  As a manager
  I can update the projects datapaths

  Scenario: Managers can add and immediately remove datapath
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And the project owner has access to 3 additional datapaths
    When I am on the project page
    Then I should be able to add a datapath to the project
    And I should be able to immediately remove the datapath

  Scenario: User cannot add a datapath
    Given I am signed in as a user
    And I belong to a project
    And there are 3 datapaths in that project
    And the project owner has access to 3 additional datapaths
    When I am on the project page
    Then I should not be able to add a datapath to the project
