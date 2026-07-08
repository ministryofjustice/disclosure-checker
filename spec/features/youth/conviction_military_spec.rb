require "rails_helper"

RSpec.feature "Conviction - Youth military", type: :feature do
  def start_military_conviction
    visit "/"
    find("label", exact_text: "Convicted").click
    click_button "Continue"
    find("label", exact_text: "Under 18").click
    click_button "Continue"
    fill_in "Day", with: "1"
    fill_in "Month", with: "1"
    fill_in "Year", with: "1999"
    click_button "Continue"
    find("label", exact_text: "Military").click
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
      subtype: "Overseas community order",
      known_date_header: "When were you given the order?",
      length_type_header: "Was the length of the order given in days, weeks, months or years?",
      length_header: "What was the length of the order?",
    },
    {
      subtype: "Service community order",
      known_date_header: "When were you given the order?",
      length_type_header: "Was the length of the order given in days, weeks, months or years?",
      length_header: "What was the length of the order?",
    },
    {
      subtype: "Service detention",
      known_date_header: "When were you given the detention?",
      length_type_header: "Was the length of the detention given in days, weeks, months or years?",
      length_header: "What was the length of the detention?",
    },
  ].each do |row|
    scenario "Military conviction with length - #{row[:subtype]}" do
      start_military_conviction
      expect(page).to have_text("What was your military conviction?")

      find("label", exact_text: row[:subtype]).click
      click_button "Continue"
      expect(page).to have_text(row[:known_date_header])

      enter_valid_date
      expect(page).to have_text(row[:length_type_header])

      find("label", exact_text: "Years").click
      click_button "Continue"
      expect(page).to have_text(row[:length_header])

      fill_in "Number of years", with: "5"
      click_button "Continue"

      check_answers_and_go_to_results
    end
  end

  scenario "Military conviction without length - Dismissal" do
    start_military_conviction
    expect(page).to have_text("What was your military conviction?")

    find("label", exact_text: "Dismissal").click
    click_button "Continue"
    expect(page).to have_text("When were you given the dismissal?")

    enter_valid_date

    check_answers_and_go_to_results
  end
end
