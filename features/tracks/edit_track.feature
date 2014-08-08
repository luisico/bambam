@javascript
Feature: Edit track information
  In order to have an up to date track
  As a user
  I can update track name and path

  Scenario: User can change the track name
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    When I visit the edit project page
    Then I should be able to update the track name

  Scenario: Admin can verfiy track properties
    Given I am signed in as an admin
    And there are 2 projects in the system
    And there is a track in that project
    When I visit the edit project page
    Then I should be able to verify track properties

  Scenario: User can change the track path
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    When I visit the edit project page
    Then I should be able to update the track path

  Scenario: Admin can change the track project
    Given I am signed in as an admin
    And there are 2 projects in the system
    And there is a track in that project
    When I visit the edit project page
    Then I should be able to change the track's project

  Scenario: User cannot change the track project
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    When I visit the edit project page
    Then I should not be able to change the track's project

  Scenario: User can change the track name on the track show page
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    When I am on the track page
    Then I should be able to edit the track name in place

  Scenario: User cannot leave track name blank on the track show page
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    When I am on the track page
    Then I should not be able to leave track name blank

  Scenario: User can change the track path on the track show page
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    When I am on the track page
    Then I should be able to edit the track path in place

  Scenario: User cannot submit an invalid track path on the track show page
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    When I am on the track page
    Then I should not be able to submit an invalid track path
