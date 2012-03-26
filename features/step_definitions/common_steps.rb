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

Then /^I should see that it was successfully imported$/ do
  page.should have_content "successfully imported!"
end

Then /^I should see a grand total of "([^"]*)"$/ do |expected_total|
  grand_total = page.find(".grand_total").find(".price")
  grand_total.should have_content expected_total
end
