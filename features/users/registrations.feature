@now
Feature: Sign up by invitation only
  In order to get access to protected sections of the site
  As a user
  I can sign up by invitation from an admin or inviter

  Scenario Outline: Invite a user
    Given I am signed in as an <role>
    And I am on the users page
    When I click on the invite user button
    Then I should be able to invite a user
    And I should see a message confirming that an invitation email has been sent
    And I should be on the users page
    And the invitee should receive an invitation

    Examples:
      | role     |
      | admin    |
      | inviter  |

  Scenario Outline: Cannot invite already registered users
    Given I am signed in as an <role>
    And I am on the users page
    When I click on the invite user button
    And I invite an already registered user
    Then the "Email" field should have the error "has already been taken"
    And I should be on the invitation page
    And no invitation should have been sent

    Examples:
      | role     |
      | admin    |
      | inviter  |

  Scenario Outline: Cannot invite if email is blank
    Given I am signed in as an <role>
    And I am on the users page
    And I click on the invite user button
    When I invite a user with a blank email
    Then the "Email" field should have the error "can't be blank"
    And I should be on the invitation page
    And no invitation should have been sent

    Examples:
      | role     |
      | admin    |
      | inviter  |

  Scenario: Regular users cannot invite another user
    Given I am signed in
    When I try to invite a user
    Then I should be denied access
    And I should be redirected to the home page

  Scenario: Invitee signs up after being invited
    Given I do not exist as a user
    When an admin user invites me
    Then I should receive an invitation
    When I click in the accept invitation email link
    Then I should be able to activate my invitation
    And I should be signed in
    And I should be on the home page

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