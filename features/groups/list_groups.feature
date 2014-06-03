Feature: List of groups
  In order to manage groups
  As a user
  I should be able to list groups

  Background:
    Given I am signed in

  Scenario: List of groups
    Given there are 10 groups in the system
    When I am on the groups page
    Then I should see a list of groups

  Scenario: Provides links to individual group pages
    Given there is a group in the system
    When I am on the groups page
    Then I should be able to acess the group page from a link
