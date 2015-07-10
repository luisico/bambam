@javascript
Feature: Delete a track
  In order to remove a track from the system
  As a user
  I can delete a track

  Scenario Outline: Delete a track from the track track show page
    Given I am signed in as <user type>
    And I <association> a project
    And <tracks exists in the project>
    When I am on the track page
    Then I <privilege> be able to delete a track from the track show page

    Examples:
      | user type | association | tracks exists in the project      | privilege  |
      | a user    | belong to   | I own 3 tracks in that project    | should     |
      | a user    | belong to   | there are 3 track in that project | should not |
      | a manager | own         | there are 3 track in that project | should     |
