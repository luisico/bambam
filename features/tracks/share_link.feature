@javascript
Feature: Create link to share track
  In order to share a track
  As a user
  I can create a shareable link

  Scenario: Create shareable link
    Given I am signed in
    And I belong to a project
    And there is a bam track in that project
    When I am on the track page
    Then I should be able to create a shareable link

  Scenario: Show a track's share link
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    And that track has a share link
    When I am on the track page
    Then I should be able to view the share link
    And I should see button to copy the track share link to the clipboard

  Scenario: Show a track's UCSC track line
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    And that track has a share link
    When I am on the track page
    Then I should be able to view the UCSC track line
    And I should see button to copy the track ucsc line to the clipboard

  Scenario: Delete a share link
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    And that track has a share link
    When I am on the track page
    Then I should be able to delete the share link

  Scenario: Renew a share link
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    And that track has a share link
    When I am on the track page
    Then I should be able to renew the share link
