Feature: Edit track information
  In order to have an up to date track
  As a user
  I can update track name and path

  Background:
    Given I am signed in

  Scenario: User can access the track edit page from the track show page
    Given there is a track in the system
    When I am on the track page
    And I click on the track edit link
    Then I should be on the edit track page

  Scenario: User can change the track name
    Given there is a track in the system
    When I visit the edit track page
    Then I should be able to edit the track name

  Scenario: User can change the track path
    Given there is a track in the system
    When I visit the edit track page
    Then I should be able to edit the track path
