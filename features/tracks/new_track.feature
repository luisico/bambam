@javascript
Feature: Create a track
  In order to add a new track to a project
  As a user
  I want to be able to access a page where I can add a new track

  Background:
    Given I am signed in
    And I belong to a project

  Scenario: User can add a new track to the project
    When I visit the edit project page
    Then I should be able to add a track to the project

  Scenario: Cannot create a track without a name
    When I visit the edit project page
    And I create a track without a name
    Then the page should have the error can't be blank
    And I should be on the edit project page

  Scenario: Cannot create a track without a path
    When I visit the edit project page
    And I create a track without a path
    Then the page should have the error can't be blank
    And I should be on the edit project page

  Scenario: Text explaining allowed paths uses the env variable ALLOWED_TRACK_PATHS
    Given environment variable ALLOWED_TRACK_PATHS is "/tmp/path1:/tmp/path2"
    When I visit the edit project page
    And I click the "Add Track" link
    Then I should see instructions to use the allowed paths
