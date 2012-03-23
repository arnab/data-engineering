Feature: Ability to upload a tab-separated data file into the app
  In order to upload my existing data into LivingSocial
  As a user
  I want to be able to upload tab-delimited files into the app

Scenario: Home Page should be the file import page
  Given I go to the root page
  Then I should see "Import Your Data"
  Then I should see a "Upload" button

Scenario: Not uploading a file
  When I go to the file import page
    And I click "Upload"
  Then I should see 1 validation error
    And nothing in the DB should change

Scenario: Uploading empty file
  When I upload the file "empty_file.txt"
  Then I should see 1 validation error
    And nothing in the DB should change

Scenario: File with only header and no data rows
  When I upload the file "file_with_only_header.txt"
  Then I should see 1 validation error
    And nothing in the DB should change

Scenario: File with bad format (non tab-delimited)

Scenario: File with invalid data

Scenario: File with invalid format

Scenario: Perfectly valid file
  When I upload the file "example_input.txt"
  Then I should not see any validation errors
