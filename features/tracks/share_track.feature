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
    And I should see button to copy the track ucsc line to the clipboard

