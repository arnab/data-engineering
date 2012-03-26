def attempt_signup(data)
  visit signup_path
  data.each { |field, value| fill_in field, with: value }
  click_button "Sign Up"
end

When /^I try to signup with the following details:$/ do |table|
  attempt_signup(table.hashes.first)
end

Then /^I should see that I successfully signed up$/ do
  page.should have_content "You have successfully signed up"
end

Given /^I sign up with:$/ do |table|
  attempt_signup(table.hashes.first)
  steps %Q{
    Then I should see that I successfully signed up
  }
end
