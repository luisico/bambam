Feature: Create a track
  In order to add a new track to the application
  As a user
  I want to be able to access a page where I can add a new track

  Background:
    Given I am signed in

  Scenario: User enters a new track
    When I am on the tracks page
    And I follow the new track link
    Then I should be on the new track page

    When I create a new track
    Then I should be on the track show page
    And I should see a message that the track was created successfully

  Scenario: Cannot create a track without a name
    Given I am on the new track page
    When I create a track without a name
    Then the "Track name" field should have the error "can't be blank"
    And I should be on the new track page

  Scenario: Cannot create a track without a path
    Given I am on the new track page
    When I create a track without a path
    Then the "Full path to track" field should have the error "can't be blank"
    And I should be on the new track page

  Scenario: Text explaining allowed paths uses the env variable ALLOWED_TRACK_PATHS
    Given environment variable ALLOWED_TRACK_PATHS is "/tmp/path1:/tmp/path2"
    When I am on the new track page
    Then I should see instructions to use the allowed paths
