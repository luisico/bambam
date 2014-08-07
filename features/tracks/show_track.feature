Feature: Show a track
  In order to see the information about a track
  As a user
  I want to be able to access a page with all the information about a track

  Scenario Outline: Show a track's information
    Given I am signed in
    And I belong to a project
    And there is a <type> track in that project
    When I am on the track page
    Then I should see the track's name
    And I should see the track's path
    And I should see the track's project
    And I should see a link to download a <type> file
    And I <status> see a "download bai file" link
    And I should see button to copy the track path to the clipboard
    And I should see the track's timestamps
    And I should see a link to open the track in IGV
    And I should see a link to create a track line for UCSC

   Examples:
    | type | status     |
    | bam  | should     |

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

  Scenario Outline: Back button
    Given I am signed in
    And I belong to a project
    And there is a bam track in that project
    When I am on the <source> page
    And I click on the track name
    And I click "Back"
    Then I should be on the <source> page

    Examples:
      | source  |
      | tracks  |
      | project |
