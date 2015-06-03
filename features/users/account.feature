Feature: Update account information
  In order to have an up to date account
  As a user
  I can update my account information and password

  Scenario: User can change the email address
    Given I am signed in
    When I visit the edit account page
    Then I should be able to edit my email

   Scenario: User can change their first name
    Given I am signed in
    When I visit the edit account page
    Then I should be able to edit my first name

  Scenario: User can change their last name
    Given I am signed in
    When I visit the edit account page
    Then I should be able to edit my last name

  Scenario: User can change the password
    Given I am signed in
    When I visit the edit account page
    Then I should be able to edit my password

  Scenario: User cannot change the password with an invalid current password
    Given I am signed in
    When I visit the edit account page
    Then I should not be able to edit my password with an invalid current password
    And the "Current password" field should have the error "is invalid"

  Scenario: User cannot change the password if it is invalid
    Given I am signed in
    When I visit the edit account page
    Then I should not be able to edit my password if it is invalid
    And the "Password" field should have the error "is too short"

  Scenario: User cannot change the password if password confirmation is wrong
    Given I am signed in
    When I visit the edit account page
    Then I should not be able to edit my password if password confirmation is wrong
    And the "Password confirmation" field should have the error "doesn't match Password"
