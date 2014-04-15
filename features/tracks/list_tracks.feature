Feature: List of tracks
  In order to manage tracks
  As a user
  I should be able to list tracks

  Background:
    Given I am signed in

  Scenario: List of tracks
    Given there are 10 tracks in the system
    When I am on the tracks page
    Then I should see a list of tracks

  Scenario: Show IGV merge link
    Given there is a track in the system
    When I am on the tracks page
    Then I should see an IGV merge link

  Scenario: Show IGV new link
    Given there is a track in the system
    When I am on the tracks page
    Then I should see an IGV new link

  Scenario: Provides links to individual track pages
    Given there is a track in the system
    When I am on the tracks page
    Then I should be able to acess the track page from a link
