Feature: Create a datapath
  In order to add a new datapath to the application
  As an admin
  I want to be able to access a page where I can add a new datapath

  @javascript
  Scenario: Admin creates a new datapath
    Given I am signed in as an admin
    When I visit the datapaths page
    And I create a new datapath
    Then I should the new datapath in the datapath list
    And I should not see a message that no datapaths exist

  @javascript
  Scenario: Cannot create datapath with invalid path
    Given I am signed in as an admin
    When I visit the datapaths page
    And I create a new datapath with an invalid path
    Then the form should have the error "must exist in filesystem"

  @javascript
  Scenario: Admin creates a new datapath with managers
    Given I am signed in as an admin
    And there are 3 other managers in the system
    When I visit the datapaths page
    And I create a new datapath with managers
    Then I should the new datapath in the datapath list
    And I should see the datapaths users
