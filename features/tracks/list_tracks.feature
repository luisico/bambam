Feature: List of tracks
  In order to manage tracks
  As a user
  I should be able to list tracks

  Background:
    Given I am signed in
    And I belong to a project
    And there are 5 tracks in that project

  Scenario: List of tracks
    When I am on the tracks page
    Then I should see a list of tracks with IGV link

  Scenario: Provides links to individual track pages
    When I am on the tracks page
    Then I should be able to acess the track page from a link
