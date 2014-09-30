Feature: Search the application
  In order to search the application
  As a user/admin
  I want to be able to access a page with results of my search query

  Scenario: Show a list of search results
    Given I am signed in
    And I belong to a project named "best_project" with track "best_track"
    And I belong to a project named "ok_project" with track "second_best_track"
    And I belong to a project named "blah_project" with track "blah_track" and path "tmp/tracks/best.bam"
    And I belong to a project named "so_so_project" with track "so_so_track"
    And I belong to a group named "best_group" with member "best_user@example.com"
    And I belong to a group named "ok_group" with member "second_best_user@example.com"
    And I belong to a group named "bad_group" with member "bad_user@example.com"
    When I search for "best"
    Then I should see my search term in the results page
    Then I should see a list of "projects and tracks" that contain the name "best"
    And I should see a list of "groups and users" that contain the name "best"

  Scenario: Show special message when no results are returned
    Given I am signed in
    When I search for "best"
    Then I should see a message that no search results were returned

  Scenario Outline: Return to search page after clicking result
    Given I am signed in as an admin
    And I belong to a project named "best_project" with track "best_track"
    And I belong to a project named "so_so_project" with track "so_so_track"
    And I belong to a group named "best_group" with member "best_user@example.com"
    And I belong to a group named "ok_group" with member "ok_user"@example.com"
    When I search for "best"
    Then I should see a list of "projects and tracks" that contain the name "best"
    And I should see a list of "groups and users" that contain the name "best"

    When I click on the "<model>" named "best"
    Then I should be on the "<model>" page
    When I click "Back"
    Then I should see a list of "projects and tracks" that contain the name "best"
    And I should see a list of "groups and users" that contain the name "best"

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

  @javascript
  Scenario: Track path changes from truncated to full on click
    Given I am signed in as an admin
    And I belong to a project named "best_project" with track "best_track" and path "tmp/tracks/54321best12345.bam"
    When I search for "best"
    Then I should be able to toggle track path from truncated to full
