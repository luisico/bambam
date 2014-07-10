Feature: List of tracks
  In order to manage tracks
  As a user
  I should be able to list tracks

  Scenario: List of tracks
    Given I am signed in
    And I belong to a project
    And there are 3 tracks in that project
    When I am on the tracks page
    Then I should see a list of tracks with IGV link

  Scenario: Provides links to individual track pages
    Given I am signed in
    And I belong to a project
    And there are 3 tracks in that project
    When I am on the tracks page
    Then I should be able to access the track page from a link

  Scenario: User with no tracks will see instructions on how to add tracks
    Given I am signed in
    And I belong to a project
    When I am on the tracks page
    Then I should see instuctions on how to add tracks
