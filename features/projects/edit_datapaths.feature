@javascript
Feature: Edit projects datapaths
  In order to have an up to date project
  As a manager
  I can update the projects datapaths

  Scenario: Managers can add a datapath to a project
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And the project owner has access to 3 additional datapaths
    When I am on the project page
    Then I should be able to add a datapath to the project
    And I should see the datapath name

  Scenario: Managers can remove a datapath from a project
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And the project owner has access to 3 additional datapaths
    When I am on the project page
    Then I should be able to remove a datapath from the project

  Scenario: Managers can add a datapath sub-directory to the project
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And the project owner has access to 3 additional datapaths
    And one of those additional datapaths has a sub-directory
    When I am on the project page
    Then I should be able to add the datapath sub-directory to the project

  Scenario: Managers can remove a datapath sub-directory from the project
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And there is a datapath sub-directory in the project
    And the project owner has access to 3 additional datapaths
    When I am on the project page
    Then I should be able to remove the datapath sub-directory from the project

  Scenario: Managers are informed about a failed datapath addition
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And the project owner has access to 3 additional datapaths
    When I am on the project page
    Then I should be informed of a failed datapath addition
    And I should see the status code appended to the node title

  Scenario: Managers are informed about a failed datapath deletion
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And the project owner has access to 3 additional datapaths
    When I am on the project page
    Then I should be informed of a failed datapath deletion
    And I should see the status code appended to the node title

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
