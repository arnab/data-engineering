When /^I go to (.+)$/ do |page_name|
  case page_name
  when 'the file import page'
    visit '/files/new'
  else
    raise "Unknown page: #{page_name}"
  end
end

Then /^I should see a "([^"]*)" button$/ do |button_name|
  page.should have_button(button_name)
end
