@javascript
Feature: Create a track
  In order to add a new track to a project
  As a user
  I want to be able to access a page where I can add a new track

  Scenario: User can add a new track to the project
    Given I am signed in
    And I belong to a project
    And there are 3 datapaths in that project
    And there is a track in the first project's datapath
    When I am on the project page
    Then I should be able to add a track to the project
    And I should be the owner of that track
