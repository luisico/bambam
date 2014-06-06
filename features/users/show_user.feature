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
    When I am on my Account Profile page
    And I should see my email
    And I should see a link to "Edit"
