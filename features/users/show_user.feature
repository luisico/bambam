Feature: Show a user profile
  In order to see the information about my account
  As a user
  I want to be able to access a page with all the information about my account

  Scenario: Show account profile information
    Given I am signed in
    And I belong to a project
    And I belong to a group
    When I am on my account profile page
    Then I should see my user name
    And I should see my email
    And I should see my avatar
    And I should not see my datapaths
    And I should see my projects
    And I should see my groups
    And I should see a link to "Edit"

  Scenario: Manager can see their datapaths
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    When I am on my account profile page
    And I should see my datapaths

  Scenario: Manager can see instructions to get datapaths
    Given I am signed in as a manager
    And I own a project
    When I am on my account profile page
    Then I should see note to contact admin to get datapaths

  Scenario: Email appears once for user with no first or last name
    Given I am signed in
    And my first and last names are blank
    And I belong to a project
    And I belong to a group
    When I am on my account profile page
    Then I should only see my email once

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

  Scenario: Manager can access the user show page from the users page
    Given I am signed in as a manager
    And there is 1 other manager in the system
    And I am on the users page
    When I click on the user handle
    Then I should be on the account profile page
    And I should not see "My" in the "Groups" section
    And I should not see "My" in the "Datapaths" section
    And I should not see "My" in the "Projects" section

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
    And I click on "my email" in the top nav
    Then I should be on my account profile page

    And I click "Back"
    Then I should be on the <source> page

    Examples:
      | source   |
      | project  |
      | projects |
