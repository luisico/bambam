Feature: Delate a track
  In order to remove a track from the system
  As a user
  I can delete a track

  Scenario: User can access the track edit page from the tracks page
    Given I am signed in
    And I own a project
    And there is a track in that project
    When I am on the track page
    Then I should be able to delete a track

  @javascript
  Scenario: User can delete a track from the project edit page
    Given I am signed in
    And I own a project
    And there are 3 tracks in that project
    When I visit the edit project page
    Then I should be able to delete a track from the project

  @javascript
  Scenario: Admin can delete a track from the project edit page
    Given I am signed in as an admin
    And there is a project in the system
    And there are 3 tracks in that project
    When I visit the edit project page
    Then I should be able to delete a track from the project
