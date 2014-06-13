Feature: Delate a project
  In order to remove a project from the system
  As a user
  I can delete a project

  Background:
    Given I am signed in

  Scenario: User can access the project edit page from the projects page
    Given one of my projects is in the system
    When I am on the project page
    Then I should be able to delete a project
