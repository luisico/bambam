@javascript
Feature: Edit projects datapaths
  In order to have an up to date project
  As a manager
  I can update the projects datapaths

  Scenario: Managers can change project master datapaths
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And I have access to 3 additional datapaths
    When I am on the project page
    Then I should be able to add a datapath to the project
