@javascript
Feature: Create a track
  In order to add a new track to a project
  As a user
  I want to be able to access a page where I can add a new track

  Scenario: User can add a new track to the project
    Given I am signed in
    And I belong to a project
    And there are 3 datapaths in that project
    And there is a track in the first project's datapath
    When I am on the project page
    And I expand the first project's datapath
    Then I should be able to add a track to the project
    And I should see the track name and link
    And I should be the owner of that track

  Scenario: Manager must select parent projects datapath before selecting track
    Given I am signed in as a manager
    And I own a project
    And the project owner has access to 3 additional datapaths
    And there is a track in the last available datapath
    When I am on the project page
    And I expand the last available datapath
    Then I should not see a checkbox next to the track

    When I select the track parent datapath
    Then I should see a checkbox next to the track
    And I should be able to add a track to the project

  Scenario: Manager removes checkboxes from tracks when deselecting parents
    Given I am signed in as a manager
    And I own a project
    And there are 3 datapaths in that project
    And there is a track in the first project's datapath
    When I am on the project page
    And I expand the first project's datapath
    Then I should see a checkbox next to the track

    When I deselect the first project's datapath
    Then I should not see a checkbox next to the track

  Scenario: User added track fails to save
    Given I am signed in
    And I belong to a project
    And there are 3 datapaths in that project
    And there is a track in the first project's datapath
    When I am on the project page
    And I expand the first project's datapath
    And I click on a track that fails to save
    Then I should see error "my;error"

  @allow-rescue
  Scenario: User adds track to invalid datapath
    Given I am signed in
    And I belong to a project
    And there are 3 datapaths in that project
    And there is a track in the first project's datapath
    When I am on the project page
    And I expand the first project's datapath
    And I click on a track with an invalid datapath
    Then I should see error "Internal Server Error"
