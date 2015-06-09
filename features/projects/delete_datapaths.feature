@javascript
Feature: Delete projects datapaths
  In order to have an up to date project
  As a manager
  I can delete projects datapaths

  Scenario: Managers can remove a datapath from a project
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And the project owner has access to 3 additional datapaths
    When I am on the project page
    Then I should be able to remove a datapath from the project
    And I should not see the datapath name

  Scenario: Managers can remove a datapath sub-directory from the project
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And the project owner has access to 3 additional datapaths
    And there is a datapath sub-directory in the project
    When I am on the project page
    Then I should be able to remove the datapath sub-directory from the project

  Scenario: Managers are informed about a failed datapath deletion
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And the project owner has access to 3 additional datapaths
    When I am on the project page
    Then I should be informed of a failed datapath deletion
    And I should see "Record not deleted" appended to the node title
