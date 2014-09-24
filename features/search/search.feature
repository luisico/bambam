Feature: Search the application
  In order to search the application
  As a user/admin
  I want to be able to access a page with results of my search query

  Scenario: Show a list of search results
    Given I am signed in as an admin
    And I belong to a project a project called "best_project"
    And there is a track in that project called "best_track"
    And I belong to a project a project called "ok_project"
    And there is a track in that project called "second_best_track"
    And I belong to a project a project called "so_so_project"
    And there is a track in that project called "so_so_track"
    And I belong to a group called "best_group"
    And I belong to a group called "ok_group"
    And there is another user in that group with email "best_user@example.com"
    And I belong to a group called "so_so_group"
    And there is another user in that group with email "ok_user"@example.com"
    When I search for "best"
    Then I should only see a list of "projects and tracks" that contain the name "best"
    And I should only see a list of "groups and users" that contain the name "best"

  Scenario: Show special message when no results are returned
    Given I am signed in
    When I search for "best"
    Then I should see a message that no search results were returned

  Scenario Outline: Return to search page after clicking result
    Given I am signed in as an admin
    And I belong to a project a project called "best_project"
    And there is a track in that project called "best_track"
    And I belong to a project a project called "so_so_project"
    And there is a track in that project called "so_so_track"
    And I belong to a group called "best_group"
    And there is another user in that group with email "best_user@example.com"
    And I belong to a group called "ok_group"
    And there is another user in that group with email "ok_user"@example.com"
    When I search for "best"
    Then I should only see a list of "projects and tracks" that contain the name "best"
    And I should only see a list of "groups and users" that contain the name "best"

    When I click on the "<model>" named "best"
    Then I should be on the "<model>" page
    When I click "Back"
    Then I should only see a list of "projects and tracks" that contain the name "best"
    And I should only see a list of "groups and users" that contain the name "best"

    Examples:
      |model   |
      |project |
      |track   |
      |group   |
      |user    |

  Scenario: Visitors cannot search
    Given I do not exist as a user
    When I visit the sign in page
    Then I should not see a search box and button
