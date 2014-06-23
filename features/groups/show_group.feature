Feature: Show a group
  In order to see the information about a group
  As a user
  I want to be able to access a page with all the information about a group

  Scenario: Show a group's information
    Given I am signed in
    And I belong to a group
    And there are 3 additional members of that group
    When I am on the group page
    Then I should see the group's name
    And I should see the group's owner
    And I should see the group's members
    And I should see the group's creation date
    And I should see the group's last update

  Scenario: Admins can manage the group
    Given I am signed in as an admin
    And there is a group in the system
    When I am on the group page
    And I should see a "Delete" button
    And I should see an "Edit" button

  Scenario: Group owners can manage the group
    Given I am signed in
    And I own a group
    When I am on the group page
    And I should see a "Delete" button
    And I should see an "Edit" button

  Scenario: Group members cannot manage the group
    Given I am signed in
    And I belong to a group
    When I am on the group page
    And I should not see a "Delete" button
    And I should not see an "Edit" button
