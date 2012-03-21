Feature: Ability to upload a tab-separated data file into the app
  In order to upload my existing data into LivingSocial
  As a user
  I want to be able to upload tab-delimited files into the app

Scenario: File with invalid format
  When I go to the file import page
  Then I should see a "Upload" button
