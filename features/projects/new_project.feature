@javascript
Feature: Create a project
  In order to add a new project to the application
  As a manager
  I want to be able to access a form where I can add a new project

  Scenario: Manager creates a new project (with just a name)
    Given I am signed in as a manager
    When I am on the projects page
    Then I should be able to create a new project
    And I should be on the project page
    And I should see a message that the project was created successfully
    And I should see myself listed as the project's owner
    When I am on the Users tab
    And I should not see my handle among the list of project member handles
    # TODO: this last step, is it repeated in show features?

  Scenario: Manager cannot create a project without a name
    Given I am signed in as a manager
    When I am on the projects page
    Then I should not be able to create a new project without a name

  Scenario: Manager can create a project without a description
    Given I am signed in as a manager
    When I am on the projects page
    Then I should be able to create a new project without a description

  Scenario: Manager can cancel out of creation of a new project
    Given I am signed in as a manager
    When I am on the projects page
    Then I should be able to cancel new project
