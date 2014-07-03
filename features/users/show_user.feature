Feature: Show a user profile
  In order to see the information about my account
  As a user
  I want to be able to access a page with all the information about my account

  Scenario: User can access their account settings page
    Given I am signed in
    When I click on "Account Profile" in the top nav
    Then I should be on the account profile page

  Scenario: Show account profile information
    Given I am signed in
    When I am on my Account Profile page
    Then I should see my email
    And I should see my avatar
    And I should see a link to "Edit"

  Scenario: Users can only see groups they are members of
    Given I am signed in
    And there are 2 groups in the system
    And I belong to 2 groups
    When I am on my Account Profile page
    Then I should only see a list of groups I am a member of

  Scenario: Show multiple projects info
    Given I am signed in
    And there are 2 projects in the system
    And I belong to 2 projects
    When I am on my Account Profile page
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
