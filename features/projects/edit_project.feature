Feature: Edit project information
  In order to have an up to date project
  As a user/admin
  I can update project name, users and tracks

  Scenario: User cannot change the project name
    Given I am signed in
    And I belong to a project
    When I visit the edit project page
    Then I should not be able to edit the project name

  Scenario: User cannot change memberships in a project
    Given I am signed in
    And I belong to a project
    And there are 3 additional users of that project
    And there are 3 other users in the system
    When I visit the edit project page
    Then I should not be able to change memberships in the project

  Scenario: Cancel out of project edit page
    Given I am signed in as an admin
    And I belong to a project
    When I visit the edit project page
    Then I should be able to cancel edit

  Scenario: Admin can change the project name
    Given I am signed in as an admin
    And there is a project in the system
    When I visit the edit project page
    Then I should be able to edit the project name

  Scenario: Admin can change memberships in project
    Given I am signed in as an admin
    And there is a project in the system
    And there are 3 additional users of that project
    And there are 3 other users in the system
    When I visit the edit project page
    Then I should be able to change memberships in the project

  Scenario: Admin can update project without changing project owner
    Given I am signed in as an admin
    And there is a project in the system
    When I visit the edit project page
    Then I should be able to update project without changing project owner

  Scenario: Admin can add itself to project
    Given I am signed in as an admin
    And there is a project in the system
    When I visit the edit project page
    Then I should be able to add myself to the project
