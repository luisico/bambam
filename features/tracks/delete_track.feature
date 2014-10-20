@javascript
Feature: Delate a track
  In order to remove a track from the system
  As a user
  I can delete a track

  Scenario: User can delete a track
    Given I am signed in
    And I belong to a project
    And there are 3 tracks in that project
    When I visit the edit project page
    Then I should be able to delete a track from the project

  Scenario: Admin can delete a track
    Given I am signed in as an admin
    And there is a project in the system
    And there are 3 tracks in that project
    When I visit the edit project page
    Then I should be able to delete a track from the project

  Scenario: User can delete a track from the track edit panel
    Given I am signed in
    And I belong to a project
    And there are 3 tracks in that project
    When I visit the edit project page
    Then I should be able to delete a track from the track edit panel

  Scenario: User can delete multiple tracks
    Given I am signed in as a user
    And I belong to a project
    And there are 3 tracks in that project
    When I visit the edit project page
    Then I should be able to delete a track from the project

  Scenario: Admin can delete multiple tracks
    Given I am signed in as an admin
    And I belong to a project
    And there are 3 tracks in that project
    When I visit the edit project page
    Then I should be able to delete a track from the project

  Scenario: User can restore track after deletion
    Given I am signed in as a user
    And I belong to a project
    And there are 3 tracks in that project
    When I visit the edit project page
    Then I should be able to restore a deleted track

  Scenario: Admin can restore track after deletion
    Given I am signed in as a admin
    And I belong to a project
    And there are 3 tracks in that project
    When I visit the edit project page
    Then I should be able to restore a deleted track
