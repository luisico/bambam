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
    And I should see the track's genome
    And I should see the track's path
    And I should see the track's project
    And I <link status> see a link to the track's owner
    And I should see a link to download a <type> file
    And I <status> see a "download bai file" link
    And I should see button to copy the track path to the clipboard
    And I should see the track's timestamps
    And I should see a link to open the track in IGV
    And I <status> see a link to open track in embedded IGV
    And I should see a link to "new"

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

  @javascript
  Scenario: IGV info tooltip
    Given I am signed in
    And I belong to a project
    And there is a bam track in that project
    When I am on the track page
    Then I should be able to activate a tooltip on the IGV button

  @javascript
  Scenario: IGV js viewer
    Given I am signed in
    And I belong to a project
    And there is a bam track in that project
    And I have previously set a locus
    When I am on the track page
    Then I should be able to activate igv js viewer
    And my track should be loaded to the last locus
    And any changes I make in the locus should be saved
