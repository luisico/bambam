@javascript
Feature: Create link to share track
  In order to share a track
  As a user
  I can create a shareable link

  Scenario: Create shareable link (expiration date defaults to 2 weeks)
    Given I am signed in
    And I belong to a project
    And there is a bam track in that project
    When I am on the track page
    Then I should be able to create a shareable link
    And I should see an expiration date of "14 days"
    And I should see "no notes" in the notes field
    And I should see a link to "edit" the share link

  Scenario Outline: Create shareable link with date short link
    Given I am signed in
    And I belong to a project
    And there is a bam track in that project
    When I am on the track page
    Then I should be able to create a link that expires in "<time>"

    Examples:
      | time    |
      | 1 week  |
      | 1 month |
      | 1 year  |

  Scenario: Shareable link with explicit expiration date
    Given I am signed in
    And I belong to a project
    And there is a bam track in that project
    When I am on the track page
    Then I should be able to create a shareable link with 7 days expiration date
    And I should see an expiration date of "7 days"

  Scenario: Cancel the creation of a shareable link
    Given I am signed in
    And I belong to a project
    And there is a bam track in that project
    When I am on the track page
    Then I should be able to cancel the creation a shareable link

  Scenario: Cannot create shareable link with expired date
    Given I am signed in
    And I belong to a project
    And there is a bam track in that project
    When I am on the track page
    Then I should not be able to create a shareable link with expired date

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

  Scenario: Cancel the renewal of a shareable link
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    And that track has a share link
    When I am on the track page
    Then I should be able to cancel the renewal the share link

  Scenario: Cannot renew a share link with expired date
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    And that track has a share link
    When I am on the track page
    Then I should not be able to renew the share link with expired date

  Scenario Outline: Renew a share link with date short link
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    And that track has a share link
    When I am on the track page
    Then I should be able to renew the link with date that expires in "<time>"

    Examples:
      | time    |
      | 1 week  |
      | 1 month |
      | 1 year  |

  Scenario: Show/hide expired links
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    And that track has a share link
    And that track has an expired share link
    When I am on the track page
    Then I should be able to show and hide the expired share links

  Scenario: Delete last expired share link
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    And that track has a share link
    And that track has an expired share link
    When I am on the track page
    Then I should be able to delete the expired share link
    And the hide/show link should not be visable
