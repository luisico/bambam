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

  Scenario: User can access help page
    Given I am signed in
    When I click on "Help" in the top nav
    Then I should be on the help page

  Scenario: Admin can access the datapaths page
    Given I am signed in as an admin
    When I click on "Datapaths" in the top nav
    Then I should be on the datapaths page

  Scenario: User cannot access the datapaths page
    Given I am signed in
    And there is not a "Datapaths" link in the navigation bar
    When I visit the datapaths page
    Then I should be denied access
    And I should be redirected to the projects page

  Scenario: User can access tracks page from home button
    Given I am signed in
    When I click on "Tracks" in the top nav
    Then I should be on the tracks page
