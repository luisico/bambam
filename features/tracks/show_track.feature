Feature: Show a track
  In order to see the information about a track
  As a user
  I want to be able to access a page with all the information about a track

  Background:
    Given I am signed in
    And I belong to a project

  Scenario Outline: Show a track's information
    Given there is a <type> track in that project
    When I am on the track page
    Then I should see the track's name
    And I should see the track's path
    And I should see the track's project
    And I should see a link to download a <type> file
    And I <status> see a "download bai file" link
    And I should see button to copy the track path to the clipboard
    And I should see the track's timestamps
    And I should see a link to open the track in IGV
    And I should see a text with the track line for UCSC
    And I should see button to copy the track ucsc line to the clipboard

   Examples:
    | type | status     |
    | bam  | should     |

  Scenario Outline: Download track
    Given there is a <type> track in that project
    When I am on the track page
    And I click on the download <ext> track link
    Then a <ext> file should download

    Examples:
      | type | ext |
      | bam  | bam |
      | bam  | bai |
      | bw   | bw  |
