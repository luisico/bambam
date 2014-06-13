Feature: Edit project information
  In order to have an up to date project
  As a user
  I can update project name, users and tracks

  Scenario: User can access the project edit page from the project show page
    Given I am signed in
    And one of my projects is in the system
    When I am on the project page
    And I click on the project edit link
    Then I should be on the edit project page

  Scenario: User can change the project name
    Given I am signed in
    And one of my projects is in the system
    When I visit the edit project page
    Then I should be able to edit the project name

  Scenario: User can change the project users
    Given I am signed in
    And one of my projects is in the system
    And there are 3 additional users of that project
    When I visit the edit project page
    Then I should be able to edit the project users

  Scenario: User can change the project tracks
    Given I am signed in
    And one of my projects is in the system
    And there are 3 additional tracks in that project
    When I visit the edit project page
    Then I should be able to edit the project tracks

  Scenario: Admin can access the project edit page from the project show page
    Given I am signed in as an admin
    And there is a project in the system
    When I am on the project page
    And I click on the project edit link
    Then I should be on the edit project page

  Scenario: Admin can change the project name
    Given I am signed in as an admin
    And there is a project in the system
    When I visit the edit project page
    Then I should be able to edit the project name

  Scenario: Admin can change the project users
    Given I am signed in as an admin
    And there is a project in the system
    And there are 3 additional users of that project
    When I visit the edit project page
    Then I should be able to edit the project users

  Scenario: Admin can change the project tracks
    Given I am signed in as an admin
    And there is a project in the system
    And there are 3 additional tracks in that project
    When I visit the edit project page
    Then I should be able to edit the project tracks

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
