require "rails_helper"

RSpec.feature "Conviction - Youth discharge", type: :feature do
  before do
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
  end

  def enter_valid_date
    fill_in "Day", with: "1"
    fill_in "Month", with: "1"
    fill_in "Year", with: "1999"
    click_button "Continue"
  end

  def check_answers_and_go_to_results
    expect(page).to have_current_path("/steps/check/check_your_answers", ignore_query: true)
    expect(page).to have_button("Add another sentence")
    expect(page).to have_button("Add a caution or conviction")
    click_button "Continue to your results"
    expect(page).to have_current_path("/steps/check/results", ignore_query: true)
  end

  scenario "Bind over" do
    find("label", exact_text: "Bind over").click
    click_button "Continue"

    expect(page).to have_css("span.govuk-caption-xl", exact_text: "Bind over")
    expect(page).to have_text("When were you given the order?")

    enter_valid_date
    expect(page).to have_text("Was the length of the order given in days, weeks, months or years?")

    find("label", exact_text: "Years").click
    click_button "Continue"
    expect(page).to have_text("What was the length of the order?")

    fill_in "Number of years", with: "2"
    click_button "Continue"

    check_answers_and_go_to_results
  end

  scenario "Absolute discharge" do
    find("label", exact_text: "Absolute discharge").click
    click_button "Continue"

    expect(page).to have_css("span.govuk-caption-xl", exact_text: "Absolute discharge")
    expect(page).to have_text("When were you given the discharge?")

    enter_valid_date

    check_answers_and_go_to_results
  end

  scenario "Conditional discharge" do
    find("label", exact_text: "Conditional discharge").click
    click_button "Continue"

    expect(page).to have_css("span.govuk-caption-xl", exact_text: "Conditional discharge")
    expect(page).to have_text("When were you given the discharge?")

    enter_valid_date
    expect(page).to have_text("Was the length of the conditions given in days, weeks, months or years?")

    find("label", exact_text: "Years").click
    click_button "Continue"
    expect(page).to have_text("What was the length of the discharge?")

    fill_in "Number of years", with: "2"
    click_button "Continue"

    check_answers_and_go_to_results
  end
end
