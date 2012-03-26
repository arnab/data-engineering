Feature: New users signing up
  In order to use this awesome app
  As a new user
  I want to sign up for the service

# All the other validations are very standard (length, presence etc.). We only test the most critical
# ones here. As a matter of fact, I don't believe testing rails goodies yields in a good test suite.
# In my experience it produces a brittle test suite.

Scenario: Unsuccessful attempt (password != confirmation)
  When I try to signup with the following details:
    | Name | Email            | Password | Confirmation |
    | joe  | joe@plumbers.org | real     | cool         |
  Then I should see a validation error "Password doesn't match confirmation"
    And I should have "0" "Users" in the DB

Scenario: Unsuccessful attempt (name and email are taken)
  Given I sign up with:
    | Name | Email            | Password | Confirmation |
    | joe  | joe@plumbers.org | awes0me  | awes0me      |
  When I try to signup with the following details:
    | Name | Email            | Password | Confirmation |
    | joe  | joe@plumbers.org | t00real  | t00coo       |
  Then I should see a validation error "Name has already been taken"
    And I should see a validation error "Email has already been taken"
    And I should have "1" "Users" in the DB

Scenario: Successful attempt
  When I try to signup with the following details:
    | Name | Email            | Password | Confirmation |
    | joe  | joe@plumbers.org | awes0me  | awes0me      |
  Then I should see that I successfully signed up
      And I should have "1" "Users" in the DB
