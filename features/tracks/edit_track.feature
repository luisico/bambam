@javascript
Feature: Edit track fields
  In order to have an up to date track
  As a user
  I can update track fields

  Scenario Outline: Edit track name
    Given I am signed in
    And I belong to a project
    And <track exists in the project>
    When I visit the track page
    Then I <privilege> be able to update the track name
    And the igv link name should match the track name

    Examples:
      | track exists in the project      | privilege  |
      | I own a track in that project    | should     |
      | there is a track in that project | should not |

  Scenario: User not allowed to set track name to blank
    Given I am signed in
    And I belong to a project
    And I own a track in that project
    When I am on the track page
    Then I should not be able to set track name to blank

  Scenario Outline: Edit track genome
    Given I am signed in
    And I belong to a project
    And <track exists in the project>
    When I visit the track page
    Then I <privilege> be able to update the track genome

    Examples:
      | track exists in the project      | privilege  |
      | I own a track in that project    | should     |
      | there is a track in that project | should not |

  Scenario: User not allowed to set track genome to blank
    Given I am signed in
    And I belong to a project
    And I own a track in that project
    When I am on the track page
    Then I should not be able to set track genome to blank

  Scenario: Failed track update
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And I own 3 tracks in that project
    When I am on the project page
    And I select an invalid track parent directory
    Then I should see error "Record not updated"
