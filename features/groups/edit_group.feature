Feature: Edit group information
  In order to have an up to date group
  As a user
  I can update group name and members

  Scenario: User can access the group edit page from the group show page
    Given I am signed in
    And I own a group
    And there are 3 additional members of that group
    When I am on the group page
    And I click on the group edit link
    Then I should be on the edit group page

  Scenario: User can change the group name
    Given I am signed in
    And I own a group
    And there are 3 additional members of that group
    When I visit the edit group page
    Then I should be able to edit the group name

  Scenario: User can change the group members
    Given I am signed in
    And I own a group
    And there are 3 additional members of that group
    When I visit the edit group page
    Then I should be able to edit the group members

  Scenario: Admin can access the group edit page from the group show page
    Given I am signed in as an admin
    And there is a group in the system
    And there are 3 additional members of that group
    When I am on the group page
    And I click on the group edit link
    Then I should be on the edit group page

  Scenario: Admin can change the group name
    Given I am signed in as an admin
    And there is a group in the system
    And there are 3 additional members of that group
    When I visit the edit group page
    Then I should be able to edit the group name

  Scenario: Admin can change the group members
    Given I am signed in as an admin
    And there is a group in the system
    And there are 3 additional members of that group
    When I visit the edit group page
    Then I should be able to edit the group members

  Scenario: Admin can update group without changing group owner
    Given I am signed in as an admin
    And there is a group in the system
    And there are 3 additional members of that group
    When I visit the edit group page
    Then I should be able to update group without changing group owner

  Scenario: Admin can add itself to group
    Given I am signed in as an admin
    And there is a group in the system
    And there are 3 additional members of that group
    When I visit the edit group page
    Then I should be able to add myself to the group
