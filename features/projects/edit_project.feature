Feature: Edit project information
  In order to have an up to date project
  As a user/admin
  I can update project name, users and tracks

  Scenario: User cannot change the project name
    Given I am signed in
    And I belong to a project
    When I visit the edit project page
    Then I should not be able to edit the project name

  Scenario: User cannot change users in a project
    Given I am signed in
    And I belong to a project
    And there are 3 additional users of that project
    And there are 3 other users in the system
    When I visit the edit project page
    Then I should not be able to change users in the project

  Scenario: Cancel out of project edit page
    Given I am signed in as an admin
    And I belong to a project
    When I visit the edit project page
    Then I should be able to cancel edit

  Scenario: Project owner sees their name under project owner
    Given I am signed in as an admin
    And I own a project
    When I visit the edit project page
    Then I should see myself listed as project owner

  Scenario: Non project owner admin should not see their name under project owner
    Given I am signed in as an admin
    And I belong to a project
    When I visit the edit project page
    Then I should not see myself listed as project owner

  Scenario: Admin can change the project name
    Given I am signed in as an admin
    And there is a project in the system
    When I visit the edit project page
    Then I should be able to edit the project name

  @javascript
  Scenario: Admin can change users in project
    Given I am signed in as an admin
    And there is a project in the system
    And there are 3 additional users of that project
    And there are 3 other users in the system
    When I visit the edit project page
    Then I should be able to change users in the project

  Scenario: Admin can update project without changing project owner
    Given I am signed in as an admin
    And there is a project in the system
    When I visit the edit project page
    Then I should be able to update project without changing project owner

  @javascript
  Scenario: Admin can add itself to project
    Given I am signed in as an admin
    And there is a project in the system
    When I visit the edit project page
    Then I should be able to add myself to the project
