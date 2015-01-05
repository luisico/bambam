@javascript
Feature: Create a project
  In order to add a new project to the application
  As a manager
  I want to be able to access a form where I can add a new project

  # @javascript
  # Scenario: Manager goes to new project page
  #   Given I am signed in as a manager
  #   And there are 3 other users in the system
  #   And I am on the new project page
  #   Then I should see myself listed as project owner
  #   And I should see a list of potential users
  #   And I should see a link to "Add a track"

  Scenario: Manager creates a new project
    Given I am signed in as a manager
    When I am on the projects page
    Then I should be able to create a new project
    And I should be on the project page
    And I should be the project's owner
    And I should see my handle among the list of project member handles

  Scenario: Manager cannot create a project without a name
    Given I am signed in as a manager
    When I am on the projects page
    Then I should not be able to create a new project without a name

  # @javascript
  # Scenario: Manager can add multiple users to a project
  #   Given I am signed in as a manager
  #   And there are 3 other users in the system
  #   And I am on the new project page
  #   When I create a project with multiple users
  #   Then I should be on the project show page
  #   And I should see the project's users with profile links
  #   And I should see a message that the project was created successfully

  # @javascript
  # Scenario: Manager can add multiple tracks to a project
  #   Given I am signed in as a manager
  #   And there is 1 other user in the system
  #   And I am on the new project page
  #   When I create a project with multiple tracks
  #   Then I should be on the project show page
  #   And I should see the project's tracks
  #   And I should see a message that the project was created successfully

  Scenario: Manager can cancel out of project new page
    Given I am signed in as a manager
    When I am on the projects page
    Then I should be able to cancel new project

  # @javascript
  # Scenario: Manager can delete a track before creating project
  #   Given I am signed in as a manager
  #   And there is 1 other user in the system
  #   When I am on the new project page
  #   And I delete a track before creating project
  #   Then I should not create a new track
