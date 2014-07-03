Feature: Show a project
  In order to see the information about a project
  As a user
  I want to be able to access a page with all the information about a project

  Scenario: User can access the project show page from the projects page
    Given I am signed in
    And I belong to a project
    When I am on the projects page
    And I click on the project name
    Then I should be on the show project page

  Scenario Outline: Show a project's information
    Given I am signed in as a <user_type>
    And I belong to a project
    When I am on the project page
    Then I should see the project's name
    And I should see the projects tracks
    And I should see the project's users <privilege> profile links
    And I should see the project's creation date
    And I should see the date of the project's last update
    And I <privilege2> see a delete button

    Examples:
      | user_type | privilege | privilege2 |
      | admin     | with      | should     |
      | user      | without   | should not |
