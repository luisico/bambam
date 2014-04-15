Feature: Delate a track
  In order to remove a track from the system
  As a user
  I can delete a track

  Background:
    Given I am signed in

  Scenario: User can access the track edit page from the tracks page
    Given there is a track in the system
    When I am on the tracks page
    Then I should be able to delete a track
