@javascript
Feature: Delete a datapath
  In order to remove a datapath from the system
  As an admin
  I can delete a datapath

  Scenario: Admin can delete a datapath
    Given I am signed in as an admin
    And there are 3 datapaths in the system
    When I visit the datapaths page
    Then I should be able to delete the datapath

  Scenario: Admin deletes the last datapath
    Given I am signed in as an admin
    And there is 1 datapath in the system
    When I visit the datapaths page
    Then I should be able to delete the datapath
    And I should see a message that no datapaths exist
