require "markup_normaliser"

Then(/^The form markup should match "([^"]*)"$/) do |fixture|
  raw_markup = page.all(
    :css, "form > div.govuk-form-group"
  ).map { |div| div["outerHTML"] }.join

  raw_fixture = Pathname.new(
    File.join("features", "fixtures", "files", "#{fixture}.html"),
  ).read

  normaliser = MarkupNormaliser.new(raw_markup, raw_fixture)

  expect(
    normaliser.markup1,
  ).to eq(
    normaliser.markup2,
  )
end

Then(/^The form markup with errors should match "([^"]*)"$/) do |fixture|
  # Click continue without filling anything, to trigger validation errors
  step %(I click the "Continue" button)

  # Now check the markup with errors using the above step
  step %(The form markup should match "#{fixture}")
end
