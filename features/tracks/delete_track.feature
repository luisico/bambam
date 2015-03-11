@javascript
Feature: Delate a track
  In order to remove a track from the system
  As a user
  I can delete a track
  @now
  Scenario Outline: Delete a track
    Given I am signed in
    And I belong to a project
    And there are 3 datapaths in that project
    And <tracks exists in the project>
    When I am on the project page
    Then I <privilege> be able to delete a track from the project

    Examples:
      | tracks exists in the project      | privilege  |
      | I own 3 tracks in that project    | should     |
      | there are 3 track in that project | should not |

#   Scenario: Manager can delete any track in their project
#     Given I am signed in as a manager
#     And I own a project
#     And there are 3 tracks in that project
#     When I visit the edit project page
#     Then I should be able to delete a track from the project

#   Scenario: Admin can delete any track
#     Given I am signed in as an admin
#     And there is a project in the system
#     And there are 3 tracks in that project
#     When I visit the edit project page
#     Then I should be able to delete a track from the project

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

#   Scenario Outline: User can delete multiple tracks
#     Given I am signed in as a user
#     And I belong to a project
#     And <tracks exists in the project>
#     When I visit the edit project page
#     Then I <privilege> be able to delete a track from the project

#     Examples:
#       | tracks exists in the project      | privilege  |
#       | I own 3 tracks in that project    | should     |
#       | there are 3 track in that project | should not |

#   Scenario: Admin can delete multiple tracks
#     Given I am signed in as an admin
#     And I belong to a project
#     And there are 3 tracks in that project
#     When I visit the edit project page
#     Then I should be able to delete a track from the project

#   Scenario: User can restore track after deletion
#     Given I am signed in as a user
#     And I belong to a project
#     And I own 3 tracks in that project
#     When I visit the edit project page
#     Then I should be able to restore a deleted track

#   Scenario: User must restore track before editing
#     Given I am signed in as a user
#     And I belong to a project
#     And I own 3 tracks in that project
#     When I visit the edit project page
#     Then I should not be able to edit a deleted track

#   Scenario: Admin can restore track after deletion
#     Given I am signed in as a admin
#     And I belong to a project
#     And there are 3 tracks in that project
#     When I visit the edit project page
#     Then I should be able to restore a deleted track
