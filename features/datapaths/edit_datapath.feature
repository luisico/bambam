@javascript
Feature: Edit datapath information
  In order to have an up to date set of datapaths
  As a an admin
  I can update datapath path and users

  Scenario: Admin a can change datapath users
    Given I am signed in as an admin
    And there is a datapath in the system
    And that datapath has 2 managers
    And there are 3 other managers in the system
    When I visit the datapaths page
    Then I should be able to change users in the datapath

  Scenario: Admin a can change datapath path
    Given I am signed in as an admin
    And there are 3 datapaths in the system
    And that datapath has 2 managers
    When I visit the datapaths page
    Then I should be able to change the datapath path

  Scenario: Admin cancel datapath edit
    Given I am signed in as an admin
    And there are 3 datapaths in the system
    And that datapath has 2 managers
    When I visit the datapaths page
    Then I should be able cancel the edit of a datapath
