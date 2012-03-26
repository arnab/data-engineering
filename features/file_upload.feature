Feature: Ability to upload a tab-separated data file into the app
  In order to upload my existing data into LivingSocial
  As a user
  I want to be able to upload tab-delimited files into the app

Scenario: Perfectly valid file
  When I upload the file "example_input.txt"
  Then I should see that it was successfully imported
    And I should have "3" "Deals" in the DB
    And I should have "4" "Purchases" in the DB
    And I should see a grand total of "$95.00"

Scenario: Order of fields in file is flexible (as long as all the required fields are there)
  When I upload the file "fields_out_of_order.txt"
  Then I should see that it was successfully imported
    And I should have "3" "Deals" in the DB
    And I should have "4" "Purchases" in the DB
    And I should see a grand total of "$95.00"
