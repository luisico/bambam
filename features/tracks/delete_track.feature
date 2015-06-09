@javascript
Feature: Delete a track
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
    And I expand the first project's datapath
    Then I should be able to add a track to the project
    And I should be able to immediately delete the track

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

  Scenario: Failed track deletion
    Given I am signed in
    And I belong to a project
    And there are 3 datapaths in that project
    And I own 3 tracks in that project
    When I am on the project page
    And I deselect a track and it fails to delete
    Then I should see error "Record not deleted"
