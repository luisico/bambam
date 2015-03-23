@javascript
Feature: Delate a track
  In order to remove a track from the system
  As a user
  I can delete a track

  Scenario Outline: Delete a track
    Given I am signed in
    And I belong to a project
    And there are 3 datapaths in that project
    And <tracks exists in the project>
    When I am on the project page
    Then I <privilege> be able to delete a track from the project
    And I <result> see the track name and link

    Examples:
      | tracks exists in the project       | privilege  | result     |
      | I own 3 tracks in that project     | should     | should not |
      | there are 3 tracks in that project | should not | should     |

  Scenario: Add and immediately delete a track
    Given I am signed in
    And I belong to a project
    And there are 3 datapaths in that project
    And there is a track in the first project's datapath
    When I am on the project page
    Then I should be able to add a track to the project
    And I should be able to immediately delete the track

#   Scenario Outline: Delete a track from the track edit panel
#     Given I am signed in
#     And I belong to a project
#     And <tracks exists in the project>
#     When I visit the edit project page
#     Then I <privilege> be able to delete a track from the track edit panel

#     Examples:
#       | tracks exists in the project      | privilege  |
#       | I own 3 tracks in that project    | should     |
#       | there are 3 track in that project | should not |
