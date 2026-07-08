require "rails_helper"

RSpec.feature "Form markup smoke tests", type: :feature do
  def form_markup
    page.all(:css, "form > div.govuk-form-group").map { |div| div.native.to_html }.join
  end

  def fixture_markup(name)
    Rails.root.join("spec", "fixtures", "files", "#{name}.html").read
  end

  def expect_markup_matches(fixture_name)
    normaliser = MarkupNormaliser.new(form_markup, fixture_markup(fixture_name))
    expect(normaliser.markup1).to eq(normaliser.markup2)
  end

  def expect_markup_with_errors_matches(fixture_name)
    click_button "Continue"
    expect_markup_matches(fixture_name)
  end

  scenario "Radio button form markup should be correct" do
    visit "/"
    visit "/steps/check/kind"

    expect_markup_matches("steps_check_kind")
    expect_markup_with_errors_matches("steps_check_kind_with_errors")
  end

  scenario "Date form markup should be correct" do
    visit "/"
    find("label", exact_text: "Convicted").click
    click_button "Continue"
    find("label", exact_text: "Under 18").click
    click_button "Continue"
    fill_in "Day", with: "1"
    fill_in "Month", with: "1"
    fill_in "Year", with: "1999"
    click_button "Continue"
    find("label", exact_text: "Discharge").click
    click_button "Continue"
    find("label", exact_text: "Bind over").click
    click_button "Continue"

    expect_markup_matches("steps_conviction_known_date")
    expect_markup_with_errors_matches("steps_conviction_known_date_with_errors")
  end
end
