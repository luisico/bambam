Feature: Search the application
  In order to search the application
  As a user/admin
  I want to be able to access a page with results of my search query

  Scenario: Show a list of search results
    Given I am signed in
    And I belong to a project named "best_project" with track "best_track"
    And that project has a user "best_yet@example.com"
    And I belong to a group named "best_group" with member "best_user@example.com"
    When I search for "best"
    Then I should see my search term in the results page
    And I should see a section for projects and tracks
    And I should see a section for groups and users

  Scenario: Show special message when no results are returned
    Given I am signed in
    When I search for "best"
    Then I should see a message that no search results were returned

  Scenario Outline: Return to search page after clicking result
    Given I am signed in as an admin
    And I belong to a project named "best_project" with track "best_track"
    And that project has a user "best_yet@example.com"
    And I belong to a group named "best_group" with member "best_user@example.com"
    When I search for "best"
    Then I should see a section for projects and tracks
    And I should see a section for groups and users

    When I click on the "<model>" named "best"
    Then I should be on the "<model>" page
    When I click "Back"
    Then I should see a section for projects and tracks
    And I should see a section for groups and users

    Examples:
    | model   |
    | project |
    | track   |
    | group   |
    | user    |

  Scenario: Visitors cannot search
    Given I do not exist as a user
    When I visit the sign in page
    Then I should not see a search box and button

  @javascript
  Scenario: Track path changes from truncated to full on click
    Given I am signed in as an admin
    And I belong to a project named "best_project" with track "best_track" and path "tmp/tracks/54321best12345.bam"
    When I search for "best"
    Then I should see the full track path on mouseover
    And I should be able to toggle track path from truncated to full

  @javascript
  Scenario: IGV info tooltip
    Given I am signed in as a user
    And I belong to a project named "best_project" with track "best_track"
    And I belong to a project named "ok_project" with track "second_best_track"
    When I search for "best"
    Then I should be able to activate a tooltip on the IGV buttons
