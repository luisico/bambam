Feature: Show a project
  In order to see the information about a project
  As a user
  I want to be able to access a page with the proper information about a project

  @javascript
  Scenario Outline: Show a project's information
    Given I am signed in as <role>
    And <project exists>
    And there are 3 additional users of that project
    And there are 3 datapaths in that project
    And there are 3 tracks in that project
    When I am on the project page
    Then I should see the project's name
    And I should see a project track count of "3"
    And I should see tabs labled Files, Users and IGV
    And I should see a section titled "<title>"
    And I should see a note about contacting "<contact>"
    And I should see the project's tracks
    And I should see the project's owner
    And I should see the project's timestamps
    When I am on the Users tab
    And I should see the project's users <privilege> profile links
    And I <privilege2> see a "Delete" button

    Examples:
      | role      | title                | contact | project exists        | privilege | privilege2 |
      | an admin  | Datapaths and Tracks | admin   | I belong to a project | with      | should     |
      | a manager | Tracks               | owner   | I belong to a project | with      | should not |
      | a manager | Datapaths and Tracks | admin   | I own a project       | with      | should     |
      | a user    | Tracks               | owner   | I belong to a project | without   | should not |

  @javascript
  Scenario: User can view project tracks in js igv
    Given I am signed in
    And I belong to a project
    And there is a bam track in that project
    And I had previously set a project locus
    When I am on the project page
    And I am on the IGV tab
    Then the igv js viewer should be activated
    And the locus should be loaded to the last locus
    And I should be able to load a track into the viewer
    And any changes I make in the locus should be saved

  Scenario: User can access the tracks page
    Given I am signed in
    And I belong to a project
    And there is a bam track in that project
    When I am on the project page
    And I click "tracks"
    Then I should be on the tracks page

  @javascript
  Scenario: User can access a track show page
    Given I am signed in
    And I belong to a project
    And there is a bam track in that project
    When I am on the project page
    And I click on the track name
    Then I should be on the show track page

  @javascript
  Scenario: Manager can designate user read only
    Given I am signed in as a manager
    And I own a project
    And there are 3 additional users of that project
    And there are 3 datapaths in that project
    And there are 3 tracks in that project
    When I am on the project page
    And I am on the Users tab
    Then I should be able to designate a user read only
    And that user should move to the read-only list
    And the regular user counts should be 2
    And the read only user count should be 1

  @javascript
  Scenario: Manager can remove user from read only list
    Given I am signed in as a manager
    And I own a project
    And there are 3 additional users of that project
    And there are 3 datapaths in that project
    And there are 3 tracks in that project
    And there is a read only user in that project
    When I am on the project page
    And I am on the Users tab
    Then I should be able to remove a user from the read only list
    And that user should move to the regular user list
    And the regular user counts should be 3
    And the read only user count should be 0

  Scenario Outline: Back button
    Given I am signed in
    And I belong to a project
    When I am on the <source> page
    And I click on the project name
    And I click "Back"
    Then I should be on the <source> page

    Examples:
      | source          |
      | account profile |
      | projects        |

  @javascript
  Scenario: IGV info tooltip
    Given I am signed in as a user
    And I belong to a project
    And there are 3 datapaths in that project
    And there are 3 tracks in that project
    When I am on the project page
    Then I should be able to activate a tooltip on the IGV buttons
