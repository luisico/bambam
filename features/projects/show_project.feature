Feature: Show a project
  In order to see the information about a project
  As a user
  I want to be able to access a page with the proper information about a project

  Scenario Outline: Show a project's information
    Given I am signed in as <role>
    And <project exists>
    And there are 3 additional users of that project
    And there are 3 tracks in that project
    When I am on the project page
    Then I should see the project's name
    And I should see the project's tracks
    And I should see the project's users <privilege> profile links
    And I should see the project's owner
    And I should see the project's timestamps
    And I should see a button to "<button>" project
    And I <privilege2> see a "Delete" button

    Examples:
      | role      | project exists        | privilege | button             | privilege2 |
      | an admin  | I belong to a project | with      | Edit               | should     |
      | a manager | I belong to a project | with      | Add or edit tracks | should not |
      | a manager | I own a project       | with      | Edit               | should     |
      | a user    | I belong to a project | without   | Add or edit tracks | should not |

  Scenario: User can access the tracks page
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    When I am on the project page
    And I click "tracks"
    Then I should be on the tracks page

  Scenario: User can access a track show page
    Given I am signed in
    And I belong to a project
    And there is a track in that project
    When I am on the project page
    And I click on the track name
    Then I should be on the show track page

  Scenario: User can access the project edit page
    Given I am signed in
    And I belong to a project
    When I am on the project page
    And I click "Add or edit tracks"
    Then I should be on the edit project page

  @javascript
  Scenario: Admin can designate user read only
    Given I am signed in as an admin
    And I belong to a project
    And there are 3 additional users of that project
    And there are 3 tracks in that project
    When I am on the project page
    Then I should be able to designate a user read only

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
    And there are 3 tracks in that project
    When I am on the project page
    Then I should be able to activate a tooltip on the IGV buttons
