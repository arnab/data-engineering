When /^I go to (.+)$/ do |page_name|
  case page_name
  when 'the file import page'
    visit '/files/new'
  else
    raise "Unknown page: #{page_name}"
  end
end
