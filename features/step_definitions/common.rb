When(/^I visit "([^"]*)"$/) do |path|
  visit path
end

Then(/^I should be on "([^"]*)"$/) do |page_name|
  expect("#{Capybara.app_host}#{URI.parse(current_url).path}").to eql("#{Capybara.app_host}#{page_name}")
end

Then(/^I should see "([^"]*)"$/) do |text|
  expect(page).to have_text(text)
end

Then(/^I should not see "([^"]*)"$/) do |text|
  expect(page).not_to have_text(text)
end

Then(/^I should see a "([^"]*)" link to "([^"]*)"$/) do |text, href|
  expect(page).to have_link(text, href: href)
end

When(/^I click the "([^"]*)" link$/) do |text|
  click_link(text)
end

When(/^I click the "([^"]*)" button$/) do |text|
  begin
    find("input[value='#{text}']").click
  rescue Capybara::Poltergeist::MouseEventFailed
    find("input[value='#{text}']").trigger('click')
  end
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in(field, with: value)
end

When(/^I click the radio button "([^"]*)"$/) do |text|
  find('label', text: text).click
end

When(/^I choose "([^"]*)"$/) do |text|
  step %[I click the radio button "#{text}"]
  find('[name=commit]').click
end

And(/^I choose "([^"]*)" and fill in "([^"]*)" with "([^"]*)"$/) do |text, field, value|
  step %[I click the radio button "#{text}"]
  step %[I fill in "#{field}" with "#{value}"]
  find('[name=commit]').click
end
