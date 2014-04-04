Feature: List of tracks
  In order to manage tracks
  As a user
  I should be able to list tracks

  Scenario: List of tracks
    Given I am signed in
    And there are 10 tracks in the system
    When I visit the tracks page
    Then I should see a list of tracks
