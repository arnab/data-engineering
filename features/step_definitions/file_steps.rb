When /^I upload the file "([^"]*)"$/ do |filename|
  steps %Q{
      When I go to the file import page
    }
  path = File.join(::Rails.root, 'examples', filename)
  attach_file("file", path)
  click_button("Upload")
end
