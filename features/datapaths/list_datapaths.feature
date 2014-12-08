Feature: List of datapaths
  In order to manage datapaths
  As an admin
  I should be able to list datapaths

  Scenario: Admin can view list of all datapaths
    Given I am signed in as an admin
    And there are 3 datapaths in the system
    When I visit the datapaths page
    Then I should see a list of all datapaths

  Scenario: No datapaths will show special message
    Given I am signed in as an admin
    When I visit the datapaths page
    Then I should see a message that no datapaths exist
