Feature: Show a track
  In order to see the information about a track
  As a user
  I want to be able to access a page with all the information about a track

  Background:
    Given I am signed in

  Scenario: User can access the track show page from the tracks page
    Given there is a track in the system
    When I am on the tracks page
    And I click on the track show link
    Then I should be on the show track page

  Scenario: Show a track's information
    Given there is a track in the system
    When I am on the track page
    Then I should see the track's name
    And I should see the track's path
    And I should see the track's creation date
