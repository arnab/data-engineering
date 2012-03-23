When /^I go to (.+)$/ do |page_name|
  case page_name
  when 'the root page'
    visit '/'
  when 'the file import page'
    visit '/data_files/new'
  else
    raise "Unknown page: #{page_name}"
  end
end

Then /^I should see a "([^"]*)" button$/ do |button_name|
  page.should have_button(button_name)
end

Then /^I should see "([^"]*)"$/ do |content|
  page.should have_content(content)
end

When /^I click "([^"]*)"$/ do |button_name|
  click_button button_name
end

Then /^I should see (\d+) validation errors?$/ do |num|
  expected_str = "The form contains #{num} error"
  expected_str += "s" if num.to_i > 1
  page.should have_content(expected_str)
end

Then /^I should not see any validation errors$/ do
  page.should_not have_content /The form contains \d+ errors?/
end

Then /^nothing in the DB should change$/ do
  pending # express the regexp above with the code you wish you had
end
