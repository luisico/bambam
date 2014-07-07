Feature: Create a project
  In order to add a new project to the application
  As an admin
  I want to be able to access a page where I can add a new project

  Scenario: Admin goes to new project page
    Given I am signed in as an admin
    And there are 3 other users in the system
    And I am on the new project page
    Then my checkbox should be disabled
    And I should see unchecked checkboxes for the other users
    And I should see a link to "Add Track"

  @javascript
  Scenario: Admin creates a new project
    Given I am signed in as an admin
    And there are 3 other users in the system
    And I am on the new project page

    When I create a new project with a user and a track
    Then I should be on the project show page
    And I should see a message that the project was created successfully
    And I should see my email among the list of project member emails
    And I should be the projects owner

  Scenario: Admin cannot create a project without a name
    Given I am signed in as an admin
    And there are 3 other users in the system
    And I am on the new project page
    When I create a project without a name
    Then the "Project name" field should have the error "can't be blank"
    And I should be on the new project page

  Scenario: Admin can add multiple users to a project
    Given I am signed in as an admin
    And there are 3 other users in the system
    And I am on the new project page
    When I create a project with multiple members
    Then I should be on the project show page
    And all the project member email addresses should be on the list
    And I should see a message that the project was created successfully

  @javascript
  Scenario: Admin can add multiple tracks to a project
    Given I am signed in as an admin
    And there are 3 other users in the system
    And I am on the new project page
    When I create a project with multiple tracks
    Then I should be on the project show page
    And all the project track names should be on the list
    And I should see a message that the project was created successfully

  Scenario: User can cancel out of project new page
    Given I am signed in as an admin
    When I am on the new project page
    Then I should be able to cancel new project