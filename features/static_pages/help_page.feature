Feature: Application help page
  In order to get help with the application
  As a user
  I want to be able to access a page with helpful information

  Scenario: Show help
    Given I am signed in
    When I am on the help page
    Then I should see a section about what is bambam
    And I should see a section about using bambam
    And I should see a section about ABC
