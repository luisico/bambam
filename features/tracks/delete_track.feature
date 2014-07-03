Feature: Delate a track
  In order to remove a track from the system
  As a user
  I can delete a track

  @javascript
  Scenario: User can delete a track
    Given I am signed in
    And I belong to a project
    And there are 3 tracks in that project
    When I visit the edit project page
    Then I should be able to delete a track from the project

  @javascript
  Scenario: Admin can delete a track
    Given I am signed in as an admin
    And there is a project in the system
    And there are 3 tracks in that project
    When I visit the edit project page
    Then I should be able to delete a track from the project
