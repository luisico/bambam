Feature: Show a track
  In order to see the information about a track
  As a user
  I want to be able to access a page with all the information about a track

  Scenario Outline: Show a track's information
    Given I am signed in as <user type>
    And I belong to a project
    And there is a <type> track in that project
    When I am on the track page
    Then I should see the track's name
    And I should see the track's path
    And I should see the track's project
    And I <link status> see a link to the track's owner
    And I should see a link to download a <type> file
    And I <status> see a "download bai file" link
    And I should see button to copy the track path to the clipboard
    And I should see the track's timestamps
    And I should see a link to open the track in IGV
    And I should see a link to "Create new share link"

   Examples:
    | user type| type | link status | status     |
    | a user   | bam  | should not  | should     |
    | an admin | bw   | should      | should not |

  Scenario Outline: Download track
    Given I am signed in
    And I belong to a project
    And there is a <type> track in that project
    When I am on the track page
    And I click on the download <ext> track link
    Then a <ext> file should download

    Examples:
      | type | ext |
      | bam  | bam |
      | bam  | bai |
      | bw   | bw  |

  @javascript
  Scenario: Back button
    Given I am signed in
    And I belong to a project
    And there is a bam track in that project
    When I am on the tracks page
    And I click on the track name
    And I click "Back"
    Then I should be on the tracks page

  @javascript
  Scenario: IGV info tooltip
    Given I am signed in
    And I belong to a project
    And there is a bam track in that project
    When I am on the track page
    Then I should be able to activate a tooltip on the IGV button
