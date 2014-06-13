Feature: Create a project
  In order to add a new project to the application
  As a user
  I want to be able to access a page where I can add a new project

  Background:
    Given I am signed in
    And there are 3 other users in the system
    And there are 3 tracks in the system

  Scenario: User creates a new project (of which they must be a member)
    When I am on the projects page
    And I follow the new project link
    Then I should be on the new project page
    And my checkbox should be disabled

    When I create a new project
    Then I should be on the project show page
    And I should see a message that the project was created successfully
    And I should see my email among the list of project member emails
    And I should be the projects owner

  Scenario: Cannot create a project without a name
    Given I am on the new project page
    When I create a project without a name
    Then the "Project name" field should have the error "can't be blank"
    And I should be on the new project page

  Scenario: Can add multiple users to a project
    Given I am on the new project page
    When I create a project with multiple members
    Then I should be on the project show page
    And all the project member email addresses should be on the list
    And I should see a message that the project was created successfully

  Scenario: Can add multiple tracks to a project
    Given I am on the new project page
    When I create a project with multiple tracks
    Then I should be on the project show page
    And all the project track names should be on the list
    And I should see a message that the project was created successfully
