Feature: Application help page
  In order to get help with the application
  As a user
  I want to be able to access a page with helpful information

  Scenario: Show help
    Given I am signed in
    When I am on the help page
    Then I should see a section title "What is Bambam?"
    Then I should see a section title "Tours"
    Then I should see a section title "Projects"
    Then I should see a section title "Organizing tracks"
    Then I should see a section title "Tracks"
    Then I should see a section title "Groups"
    Then I should see a section title "Search"
    Then I should see a section title "Profile"
    Then I should see a section title "About the Applied Bioinformatics Core"
