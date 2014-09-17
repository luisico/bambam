Feature: Search the application
  In order to search the application
  As a user/admin
  I want to be able to access a page with results of my search query

  Scenario: Show a list of search results
    Given I am signed in
    And I belong to a project a project called "best_project"
    And there is a track in that project called "best_track"
    And I belong to a project a project called "ok_project"
    And there is a track in that project called "ok_track"
    And I belong to a group called "best_group"
    And I belong to a group called "ok_group"
    And there is another user in the system with email "best_user@example.com"
    When I search for "best"
    Then I should see a list of all objects that contain the name "best"
    And I should not see a list of all objects that contain the name "ok"

  Scenario: Show special message when no results are returned
    Given I am signed in
    When I search for "best"
    Then I should see a message that no search results were returned
