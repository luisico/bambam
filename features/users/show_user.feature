Feature: Show a user
  In order to see the information about my account
  As a user
  I want to be able to access a page with all the information about my account

  Scenario: User can access their account settings page
    Given I am signed in
    When I click on "Account Profile" in the top nav
    Then I should be on the account profile page

  Scenario: Show account profile information
    Given I am signed in
    And I own a group
    When I am on my Account Profile page
    Then I should see my email
    And I should see my avatar
    And I should see my groups
    And I should see a link to "Edit"

  Scenario: Show multiple groups info
    Given I am signed in
    And I own 2 groups
    And I belong to 2 groups
    When I am on my Account Profile page
    And I should see my groups

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
