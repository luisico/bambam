Feature: Show a track
  In order to see the information about a track
  As a user
  I want to be able to access a page with all the information about a track

  Background:
    Given I am signed in

  Scenario: User can access the track show page from the tracks page
    Given there is a track in the system
    When I am on the tracks page
    And I click on the track name
    Then I should be on the show track page

  Scenario Outline: Show a track's information
    Given there is a <type> track in the system
    When I am on the track page
    Then I should see the track's name
    And I should see the track's path
    And I should see a link to download a <type> file
    And I <status> see a "Download .bai file" link
    And I should see button to copy the track path to the clipboard
    And I should see the track's creation date
    And I should see the date of the track's last update
    And I should see a link to open the track in IGV
    And I should see a text with the track line for UCSC
    And I should see button to copy the track ucsc line to the clipboard

   Examples:
    | type | status     |
    | .bam | should     |
    | .bw  | should not |

  Scenario Outline: Download track
    Given there is a <type> track in the system
    When I am on the track page
    And I click on the download <type> track link
    Then a file should download

    Examples:
      | type |
      | .bam |
      | .bw  |

  Scenario: Download track index file
    Given there is a .bam track in the system
    When I am on the track page
    And I click on the "Download .bai file" link
    Then an index file should download
