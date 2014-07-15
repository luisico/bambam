Feature: Show a user profile
  In order to see the information about my account
  As a user
  I want to be able to access a page with all the information about my account

  Scenario: User can access their account settings page
    Given I am signed in
    When I click on "Account Profile" in the top nav
    Then I should be on my account profile page

  Scenario: Show account profile information
    Given I am signed in
    And I belong to a project
    And I belong to a group
    When I am on my account profile page
    Then I should see my email
    And I should see my avatar
    And I should see my projects
    And I should see my groups
    And I should see a link to "Edit"

  Scenario: Users can only see groups they are members of
    Given I am signed in
    And there are 2 groups in the system
    And I belong to 2 groups
    When I am on my account profile page
    Then I should only see a list of groups I am a member of

  Scenario: Show multiple projects info
    Given I am signed in
    And there are 2 projects in the system
    And I belong to 2 projects
    When I am on my account profile page
    And I should only see a list of projects I belong to

  Scenario Outline: Admin/inviter can access the user show page from the users page
    Given I am signed in as an <role>
    And there is another user in the system
    And I am on the users page
    When I click on the user email
    Then I should be on the account profile page
    And I should not see a link to "Edit"

    Examples:
      | role    |
      | admin   |
      | inviter |

  Scenario: Access projects page
    Given I am signed in
    And I belong to a project
    When I am on my account profile page
    And I click "projects"
    Then I should be on the projects page

  @now
  Scenario: Access tracks page
    Given I am signed in
    And I belong to a project
    When I am on my account profile page
    And I click "tracks"
    Then I should be on the tracks page

  Scenario Outline: Back button
    Given I am signed in
    And I belong to a project
    When I am on the <source> page
    And I click on "Account Profile" in the top nav
    Then I should be on my account profile page

    And I click "Back"
    Then I should be on the <source> page

    Examples:
      | source   |
      | project  |
      | projects |
