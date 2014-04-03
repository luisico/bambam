Feature: Reset password
  In order to get access to the site
  As a user that forgot his password
  I want to be able to reset my password

  Scenario: Already signed in user cannot reset password
    Given I am signed in
    When I visit the page to reset my password
    Then I see an already signed in message

  Scenario: User successfully requests an email with password reset instructions
    Given I exist as a user
    And I am not signed in
    When I ask for reset password instructions
    Then I should receive an email with reset password instructions
    And I should have a reset password token set

  Scenario: User successfully resets password from the email instructions
    Given I exist as a user
    And I am not signed in
    When I ask for reset password instructions
    And I follow the reset password link
    Then I should see the password change page

    When I change my password
    Then I should be signed in
    And I should see the password changed successfully message

  Scenario: User reset password token is wrong
    Given I exist as a user
    And I am not signed in
    When I use a wrong reset password token
    Then I should see the password change page

    When I change my password
    Then I should see the password change page again

  Scenario: Already signed in user follows reset password link
    Given I am signed in
    When I visit the page to change my password
    Then I see an already signed in message

  Scenario: User enters wrong email when requesting password reset email
    Given I exist as a user
    And I am not signed in
    When I ask for reset password instructions with a wrong email address
    Then I should see the password reset sent email instructions page

  Scenario: User does not enter email when requesting password reset email
    Given I exist as a user
    And I am not signed in
    When I ask for reset password instructions with a blank email address
    Then I should see the password reset sent email instructions page

  Scenario: Show help links when requesting new password
    Given I am not signed in
    When I visit the page to reset my password
    Then I should see a sign in link

  Scenario: Show help links when changing password
    Given I exist as a user
    And I am not signed in
    When I ask for reset password instructions
    And I follow the reset password link
    Then I should see the password change page
    And I should see a sign in link
