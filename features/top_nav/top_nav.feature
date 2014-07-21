Feature: Top navigation
  In order to navigate the site
  As a user
  I should be able to link to pages from the top navbar

  Scenario: Home button routes to sign_up page for visitors
    Given I do not exist as a user
    When I visit the sign up page
    And I click on "Bambam" in the top nav
    Then I should be on the root page

  Scenario: User can access projects page from home button
    Given I am signed in
    When I click on "Bambam" in the top nav
    Then I should be on the projects page

  Scenario: User can access their account settings page
    Given I am signed in
    When I click on "my email" in the top nav
    Then I should be on my account profile page
