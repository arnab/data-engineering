Then /^nothing in the DB should change$/ do
  # Before every scenario our test DB is cleaned up by database_cleaner.
  # So just verify that we have 0 rows imported.
  [Deal, Purchase].each do |model|
    model.all.count.should be_zero
  end
end

Then /^I should have "([^"]*)" "([^"]*)" in the DB$/ do |count, entity|
  model_klass = Module.const_get(entity.singularize)
  model_klass.count.should == count.to_i
end
