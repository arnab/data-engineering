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
  When I upload the file "example_input.csv"
  Then I should see 9 validation errors
    And nothing in the DB should change

Scenario: File with not enough columns in every line
  When I upload the file "five_columns.txt"
  Then I should see 8 validation errors
    And nothing in the DB should change

Scenario: File with not enough columns in one line
  When I upload the file "five_columns_in_one_line.txt"
  Then I should see 3 validation error
    And nothing in the DB should change

Scenario: File with invalid data (missing price)
  When I upload the file "missing_price.txt"
  Then I should see 2 validation errors
    And nothing in the DB should change

Scenario: File with invalid data (non numeric price)
  When I upload the file "non_numeric_price.txt"
  Then I should see 1 validation error
    And nothing in the DB should change

Scenario: File with invalid data (negative price)
  When I upload the file "negative_price.txt"
  Then I should see 1 validation error
    And nothing in the DB should change

Scenario: Mis-named headers

Scenario: Duplicate file is detected

Scenario: Perfectly valid file
  When I upload the file "example_input.txt"
  Then I should not see any validation errors

Scenario: Order is not important as long as all the fields are there and the header is known
