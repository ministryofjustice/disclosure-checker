require "rails_helper"

RSpec.feature "Conviction - Discharge", type: :feature do
  def start_discharge_conviction
    visit "/"
    find("label", exact_text: "Convicted").click
    click_button "Continue"
    find("label", exact_text: "18 or over").click
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

  [
    {
      subtype: "Conditional discharge",
      known_date_header: "When were you given the discharge?",
      length_type_header: "Was the length of the conditions given in days, weeks, months or years?",
      length_header: "What was the length of the discharge?",
    },
    {
      subtype: "Bind over",
      known_date_header: "When were you given the order?",
      length_type_header: "Was the length of the order given in days, weeks, months or years?",
      length_header: "What was the length of the order?",
    },
  ].each do |row|
    scenario "Adult discharge - #{row[:subtype]}" do
      start_discharge_conviction
      expect(page).to have_text("What discharge were you given?")

      find("label", exact_text: row[:subtype]).click
      click_button "Continue"
      expect(page).to have_text(row[:known_date_header])

      enter_valid_date
      expect(page).to have_text(row[:length_type_header])

      find("label", exact_text: "Years").click
      click_button "Continue"
      expect(page).to have_text(row[:length_header])

      fill_in "Number of years", with: "10"
      click_button "Continue"

      check_answers_and_go_to_results
    end
  end

  scenario "Adult discharge - Absolute discharge" do
    start_discharge_conviction
    expect(page).to have_text("What discharge were you given?")

    find("label", exact_text: "Absolute discharge").click
    click_button "Continue"

    expect(page).to have_css("span.govuk-caption-xl", exact_text: "Absolute discharge")
    expect(page).to have_text("When were you given the discharge?")

    enter_valid_date

    check_answers_and_go_to_results

    expect(page).to have_text("This conviction will not appear on a basic DBS check.")
    expect(page).to have_text("Your results say your caution or conviction may appear on a DBS check.")
  end
end
