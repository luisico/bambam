@now
Feature: Delate a group
  In order to remove a group from the system
  As a user
  I can delete a group

  Background:
    Given I am signed in

  Scenario: User can access the group edit page from the groups page
    Given one of my groups is in the system
    When I am on the group page
    Then I should be able to delete a group
