Feature: List of groups
  In order to manage groups
  As an admin
  I should be able to list groups

  Scenario: Admins can see all groups
    Given I am signed in as an admin
    And there are 3 groups in the system
    When I am on the groups page
    Then I should see a list of all groups

    When I click on the group name
    Then I should be on the show group page

  Scenario: Users can only see groups they are members of (owners are also members)
    Given I am signed in
    And there are 3 groups in the system
    And I belong to 3 groups
    When I am on the groups page
    Then I should only see a list of groups I am a member of

    When I click on the group name
    Then I should be on the show group page

