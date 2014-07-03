@javascript
Feature: Edit track information
  In order to have an up to date track
  As a user
  I can update track name and path

  Background:
    Given I am signed in
    And I belong to a project
    And there is a track in that project

  Scenario: User can change the track name
    When I visit the edit project page
    Then I should be to udpate the track name

  Scenario: User can change the track path
    When I visit the edit project page
    Then I should be to udpate the track path
