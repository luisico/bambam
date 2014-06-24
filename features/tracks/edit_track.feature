Feature: Edit track information
  In order to have an up to date track
  As a user
  I can update track name and path

  Background:
    Given I am signed in
    And I own a project
    And there is a track in that project

  Scenario: User can access the track edit page from the track show page
    When I am on the track page
    And I click on the track edit link
    Then I should be on the edit track page

  Scenario: User can change the track name on the track edit page
    When I visit the edit track page
    Then I should be able to edit the track name

  Scenario: User can change the track path on the track edit page
    When I visit the edit track page
    Then I should be able to edit the track path

  @javascript
  Scenario: User can change the track name on the project edit page
    When I visit the edit project page
    Then I should be to udpate the track name on the project edit page

  @javascript
  Scenario: User can change the track path on the project edit page
    When I visit the edit project page
    Then I should be to udpate the track path on the project edit page
