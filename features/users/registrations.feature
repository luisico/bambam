Feature: Sign up by invitation only
  In order to get access to protected sections of the site
  As a user
  I can sign up by invitation from an admin or inviter

  Scenario Outline: Invite a user
    Given I am signed in as an <role>
    And I am on the users page
    Then I <priviledge> be able to invite a user <status> inviter priviledges
    And I should see a message confirming that an invitation email has been sent
    And I should be on the users page
    And I should see the invitee email with invitation pending icon
    And the invitee should receive an invitation

    Examples:
      | role    | priviledge | status  |
      | admin   | should     | with    |
      | admin   | should     | without |
      | inviter | should not | with    |

  Scenario Outline: Admin can invite a user and add them to an existing project
    Given I am signed in as an <role>
    And there are 3 projects in the system
    And I am on the users page
    Then I <priviledge> be able to invite a user and add them to an existing project
    And I should see a message confirming that an invitation email has been sent
    And I should be on the users page
    And I should see the invitee email with invitation pending icon
    And the invitee should receive an invitation

    Examples:
      | role    | priviledge |
      | admin   | should     |
      | inviter | should not |

  Scenario Outline: Cannot invite already registered users
    Given I am signed in as an <role>
    And I am on the users page
    And I invite an already registered user
    Then the "Email" field should have the error "has already been taken"
    And I should be on the invitation page
    And no invitation should have been sent

    Examples:
      | role    |
      | admin   |
      | inviter |

  Scenario Outline: Cannot invite if email is blank
    Given I am signed in as an <role>
    And I am on the users page
    When I invite a user with a blank email
    Then the "Email" field should have the error "can't be blank"
    And I should be on the invitation page
    And no invitation should have been sent

    Examples:
      | role    |
      | admin   |
      | inviter |

  Scenario: Regular users cannot invite another user
    Given I am signed in
    When I try to invite a user
    Then I should be denied access
    And I should be redirected to the projects page

  Scenario Outline: Invitee signs up after being invited
    Given I do not exist as a user
    When an <role> user invites me
    Then I should receive an invitation
    When I click in the accept invitation email link
    Then I should be able to activate my invitation
    And I should be signed in
    And I should be on the projects page

    Examples:
      | role    |
      | admin   |
      | inviter |

  Scenario: Invitee signs up with invalid password
    When I am invited
    And I click in the accept invitation email link
    Then I should not be able to sign up with an empty password
    And the "Password" field should have the error "can't be blank"
    And the "Password confirmation" field should have the error "doesn't match Password"
    And I should be signed out

  Scenario: Invitee cannot sign up with an invalid invitation token
    When I am invited
    Then I should not be able to sign up with an invalid invitation token
    And I should see an invalid invitation token message
    And I should be signed out

  Scenario: Invitee cannot sign up after the invitation token expires
    When I am invited
    And I try to used an already expired invitation token
    Then I should see the error message "The invitation token provided is not valid!"
    And I should be signed out

  Scenario: User cannot sign up directly
    Given I do not exist as a user
    When I visit the sign up page
    Then I should find account sign up instuctions

  Scenario: User cannot cancel account
    Given I am signed in
    When I visit the cancel account page
    Then I should find account termination instructions
