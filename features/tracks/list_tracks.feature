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

  Scenario: User with no tracks will see instructions on how to add tracks
    Given I am signed in
    And I belong to a project
    When I am on the tracks page
    Then I should see instuctions on how to add tracks

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
    Then I should not see 0 tracks listed on the page

    When I click the play icon next to the project name
    Then I should not see 3 tracks listed on the page
