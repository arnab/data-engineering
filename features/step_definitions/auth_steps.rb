def attempt_signup(data)
  visit signup_path
  data.each { |field, value| fill_in field, with: value }
  click_button "Sign Up"
end

def attempt_signin(data)
  visit signin_path
  data.each { |field, value| fill_in field, with: value }
  click_button "Sign In"
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

When /^I try to signin with the following details:$/ do |table|
  attempt_signin(table.hashes.first)
end

Then /^I should be signed in$/ do
  within("nav") do
    page.should have_content "Sign out"
    page.should_not have_content "Sign in"
  end
end

Then /^I shouldn't be signed in$/ do
  within("nav") do
    page.should have_content "Sign in"
    page.should_not have_content "Sign out"
  end
end

Given /^I sign out$/ do
  click_link 'Sign out'
end
