Feature: User sign in and sign out (sessions)
  In order to navigate and interact with protected sections of the site
  A user
  Should be able to sign in and out

  Scenario: User signs in successfully
    Given I exist as a user
    And I am not signed in
    When I sign in with valid email and password
    Then I should see a successful sign in message
    And I should be signed in

  Scenario: User enters invalid email address
    Given I exist as a user
    And I am not signed in
    When I sign in with an invalid email address
    Then I should see an invalid sign in message
    And I should be signed out

  Scenario: User enters invalid password
    Given I exist as a user
    And I am not signed in
    When I sign in with an invalid password
    Then I should see an invalid sign in message
    And I should be signed out

  Scenario: User signs out
    Given I am signed in
    When I sign out
    Then I should see a signed out message
    And I should be signed out

  Scenario: Show account help links
    Given I am not signed in
    When I visit the sign in page
    Then I should see a forgot password link
