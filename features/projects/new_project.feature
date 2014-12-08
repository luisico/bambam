Feature: Create a project
  In order to add a new project to the application
  As a manager
  I want to be able to access a page where I can add a new project

  @javascript
  Scenario: Manager goes to new project page
    Given I am signed in as a manager
    And there are 3 other users in the system
    And I am on the new project page
    Then I should see myself listed as project owner
    And I should see a list of potential users
    And I should see a link to "Add a track"

  @javascript
  Scenario: Manager creates a new project
    Given I am signed in as a manager
    And there is 1 other user in the system
    And I am on the new project page

    When I create a new project with a user and a track
    Then I should be on the project show page
    And I should see a message that the project was created successfully
    And I should see my handle among the list of project member handles
    And I should be the project's owner
    And I should see the project's tracks

  Scenario: Manager cannot create a project without a name
    Given I am signed in as a manager
    And there is 1 other user in the system
    And I am on the new project page
    When I create a project without a name
    Then the "Project name" field should have the error "can't be blank"
    And I should be on the new project page

  @javascript
  Scenario: Manager can add multiple users to a project
    Given I am signed in as a manager
    And there are 3 other users in the system
    And I am on the new project page
    When I create a project with multiple users
    Then I should be on the project show page
    And I should see the project's users with profile links
    And I should see a message that the project was created successfully

  @javascript
  Scenario: Manager can add multiple tracks to a project
    Given I am signed in as a manager
    And there is 1 other user in the system
    And I am on the new project page
    When I create a project with multiple tracks
    Then I should be on the project show page
    And I should see the project's tracks
    And I should see a message that the project was created successfully

  Scenario: Manager can cancel out of project new page
    Given I am signed in as a manager
    When I am on the new project page
    Then I should be able to cancel new project

  @javascript
  Scenario: Manager can delete a track before creating project
    Given I am signed in as a manager
    And there is 1 other user in the system
    When I am on the new project page
    And I delete a track before creating project
    Then I should not create a new track
