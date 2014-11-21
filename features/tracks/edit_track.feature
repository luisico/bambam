@javascript
Feature: Edit track information
  In order to have an up to date track
  As a user
  I can update track name and path

  Scenario Outline: Edit track name
    Given I am signed in
    And I belong to a project
    And <track exists in the project>
    When I visit the edit project page
    Then I <privilege> be able to update the track name

    Examples:
      | track exists in the project      | privilege  |
      | I own a track in that project    | should     |
      | there is a track in that project | should not |

  Scenario: Admin can edit track without changing owner
    Given I am signed in as an admin
    And there is a project in the system
    And there is a track in that project
    When I visit the edit project page
    Then I should be able to update the track name
    And the track owners should not change

  Scenario: Admin can verfiy track properties
    Given I am signed in as an admin
    And there are 2 projects in the system
    And there is a track in that project
    When I visit the edit project page
    Then I should be able to verify track properties

  Scenario Outline: Edit track path
    Given I am signed in
    And I belong to a project
    And <track exists in the project>
    When I visit the edit project page
    Then I <privilege> be able to update the track path

    Examples:
      | track exists in the project      | privilege  |
      | I own a track in that project    | should     |
      | there is a track in that project | should not |

  Scenario: Admin can change the track project
    Given I am signed in as an admin
    And there are 2 projects in the system
    And there is a track in that project
    When I visit the edit project page
    Then I should be able to change the track's project

  Scenario: User cannot change the track project
    Given I am signed in
    And I belong to a project
    And I own a track in that project
    When I visit the edit project page
    Then I should not be able to change the track's project

  Scenario: Border surrounds track fields during edit
    Given I am signed in
    And I belong to a project
    And I own a track in that project
    When I visit the edit project page
    Then I should see a border when I click "track name"
    And I should not see a border when I click "done"
