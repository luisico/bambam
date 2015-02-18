@javascript
Feature: Edit projects datapaths
  In order to have an up to date project
  As a manager
  I can update the projects datapaths

  Scenario: Managers can add a project master datapaths
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And I have access to 3 additional datapaths
    When I am on the project page
    Then I should be able to add a datapath to the project

  Scenario: Managers can remove a project master datapaths
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And I have access to 3 additional datapaths
    When I am on the project page
    Then I should be able to remove a datapath from the project

  Scenario: Managers can add a sub-directory to the project
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And I have access to 3 additional datapaths
    And one of those additional datapaths has a sub-directory
    When I am on the project page
    Then I should be able to add a sub-directory to the project

  Scenario: Managers can remove a sub-directory from the project
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And one of those project datapaths has a sub-directory
    And I have access to 3 additional datapaths
    When I am on the project page
    Then I should be able to remove a sub-directory to the project

  Scenario: Managers are informed about failed project datapath creation
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And I have access to 3 additional datapaths
    When I am on the project page
    Then I should be informed of a failed datapath creation
    And I should see the status code appended to the node title

  Scenario: Managers are informed about failed project datapath deletion
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And I have access to 3 additional datapaths
    When I am on the project page
    Then I should be informed of a failed datapath deletion
    And I should see the status code appended to the node title

  Scenario: Managers can add and immediately remove datapath
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And I have access to 3 additional datapaths
    And one of those additional datapaths has a sub-directory
    When I am on the project page
    Then I should be able to add a datapath to the project
    And I should be able to immediately remove the datapath

  Scenario: User cannot add a datapath
    Given I am signed in as a user
    And I belong to a project
    And there are 3 datapaths in that project
    And I have access to 3 additional datapaths
    When I am on the project page
    Then I should not be able to add a datapath to the project
