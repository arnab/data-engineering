When /^I upload the file "([^"]*)"$/ do |filename|
  steps %Q{
      When I go to the file import page
    }
  path = File.join(::Rails.root, 'examples', filename)
  attach_file("file", path)
  click_button("Upload")
end

When /^I upload the file "([^"]*)" again$/ do |filename|
  steps %Q{
    When I upload the file "#{filename}"
  }
end

Given /^I have already uploaded the file "([^"]*)"$/ do |filename|
  steps %Q{
    When I upload the file "#{filename}"
    Then I should see that it was successfully imported
  }
end
