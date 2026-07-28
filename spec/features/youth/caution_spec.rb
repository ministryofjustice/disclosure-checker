require "rails_helper"

RSpec.feature "Caution - Youth (under 18)", type: :feature do
  before do
    visit "/"
    find("label", exact_text: "Cautioned").click
    click_button "Continue"
    find("label", exact_text: "Under 18").click
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
    expect(page).to have_button("Add a caution or conviction")
    click_button "Continue to your results"
    expect(page).to have_current_path("/steps/check/results", ignore_query: true)
  end

  scenario "Under 18, youth caution" do
    find("label", exact_text: "Youth caution").click
    click_button "Continue"

    expect(page).to have_text("When did you get the caution?")
    enter_valid_date

    check_answers_and_go_to_results
    expect(page).to have_text("This caution is spent on the day you receive it")
    expect(page).to have_text("This caution will not appear on a basic DBS check.")
  end

  scenario "Under 18, youth conditional caution" do
    find("label", exact_text: "Youth conditional caution").click
    click_button "Continue"

    expect(page).to have_text("When did you get the caution?")
    enter_valid_date

    expect(page).to have_text("When did the conditions end?")
    enter_valid_date

    check_answers_and_go_to_results
    expect(page).to have_text("This caution was spent on 1 January 1999")
    expect(page).to have_text("This caution will not appear on a basic DBS check.")
  end
end
