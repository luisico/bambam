@javascript
Feature: Add projects datapaths
  In order to manage project files
  As a manager
  I can add projects datapaths

  Scenario: Managers can add a datapath to a project
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And the project owner has access to 3 additional datapaths
    When I am on the project page
    Then I should be able to add a datapath to the project
    And I should see the datapath name

  Scenario: Managers can add a datapath sub-directory to the project
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And the project owner has access to 3 additional datapaths
    And one of those additional datapaths has a sub-directory
    When I am on the project page
    Then I should be able to add the datapath sub-directory to the project

  Scenario: Managers are informed about a failed datapath addition
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And the project owner has access to 3 additional datapaths
    When I am on the project page
    Then I should be informed of a failed datapath addition
    And I should see "Record not created" appended to the node title
