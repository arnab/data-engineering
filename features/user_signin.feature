Feature: Existing users signing in
  In order to use this awesome app
  As an existing user
  I want to sign in using my credentials

Background: Create a user
  Given I sign up with:
    | Name | Email            | Password | Confirm Password |
    | joe  | joe@plumbers.org | awes0me  | awes0me          |
  And I sign out

Scenario: Unsuccessful attempt (password wrong)
  When I try to signin with the following details:
    | Email            | Password |
    | joe@plumbers.org | real     |
  Then I should see a validation error "Invalid email/password combination"
    And I shouldn't be signed in

Scenario: Unsuccessful attempt (email wrong)
  When I try to signin with the following details:
    | Email            | Password |
    | who@plumbers.org | awes0me  |
  Then I should see a validation error "Invalid email/password combination"
    And I shouldn't be signed in

Scenario: Successful attempt followed by a sign out
  When I try to signin with the following details:
    | Email            | Password |
    | joe@plumbers.org | awes0me  |
  Then I should be signed in
  When I sign out
  Then I shouldn't be signed in
