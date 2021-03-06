Feature: List of tracks
  In order to manage tracks
  As a user
  I should be able to list tracks

  Scenario Outline: List of tracks
    Given I am signed in as <user type>
    And I belong to a project
    And there are 3 datapaths in that project
    And there are 3 tracks in that project
    When I am on the tracks page
    Then I should see a list of tracks with IGV link grouped by project
    And I <status> see a link to each track's owner

    Examples:
      | user type | status      |
      | a user    | should not  |
      | a manager | should      |

  Scenario: Provides links to individual track pages
    Given I am signed in
    And I belong to a project
    And there are 3 datapaths in that project
    And there are 3 tracks in that project
    When I am on the tracks page
    Then I should be able to access the track page from a link

  Scenario: User with no tracks and no projects
    Given I am signed in
    When I am on the tracks page
    Then I should see instuctions with a link to email an administrator

  Scenario: User with a project, but no tracks
    Given I am signed in
    And I belong to a project
    When I am on the tracks page
    Then I should see instuctions with a link to the projects page

  @javascript
  Scenario: IGV info tooltip
    Given I am signed in
    And I belong to a project
    And there are 3 datapaths in that project
    And there are 3 tracks in that project
    When I am on the tracks page
    Then I should be able to activate a tooltip on the IGV buttons

  @javascript
  Scenario: Show and hide project tracks
    Given I am signed in
    And I belong to a project
    And there are 3 datapaths in that project
    And there are 3 tracks in that project
    When I am on the tracks page
    And I click the play icon next to the project name
    Then I should see 0 tracks on the index page

    When I click the play icon next to the project name
    Then I should see 3 tracks on the index page

  @javascript
  Scenario Outline: Filter list of tracks
    Given I am signed in
    And I belong to a project named "best_project" with track "best_track"
    And I belong to a project named "second_best_project" with track "ok_track"
    And I belong to a project named "ok_project" with track "ok_track"
    And I belong to a project named "so_so_project" with track "so_so_track"
    When I am on the tracks page
    And I filter tracks on "<filter>"
    Then I should see <result1>
    And I should see <result2>

    When I click on clear
    Then the input field should be clear
    And I should see 4 tracks on the index page
    And I should see no text highlights

    Examples:
    | filter | result1                     | result2            |
    | best   | 2 tracks on the index page  | 3 text highlights  |
    | foo    | a no tracks matched message | no text highlights |
