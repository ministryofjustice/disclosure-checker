require "rails_helper"

RSpec.feature "Conviction - Youth referral or rehabilitation order (YRO)", type: :feature do
  def start_yro_conviction
    visit "/"
    find("label", exact_text: "Convicted").click
    click_button "Continue"
    find("label", exact_text: "Under 18").click
    click_button "Continue"
    fill_in "Day", with: "1"
    fill_in "Month", with: "1"
    fill_in "Year", with: "1999"
    click_button "Continue"
    find("label", exact_text: "Referral or youth rehabilitation order (YRO)").click
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
      subtype: "Referral order",
      known_date_header: "What was the date of your first panel meeting?",
    },
    {
      subtype: "Supervision order",
      known_date_header: "When were you given the order?",
    },
    {
      subtype: "Youth rehabilitation order",
      known_date_header: "When were you given the order?",
    },
  ].each do |row|
    scenario row[:subtype] do
      start_yro_conviction
      expect(page).to have_text("What was your referral or youth rehabilitation order (YRO)?")

      find("label", exact_text: row[:subtype]).click
      click_button "Continue"
      expect(page).to have_text(row[:known_date_header])

      enter_valid_date
      expect(page).to have_text("Was the length of the order given in days, weeks, months or years?")

      find("label", exact_text: "Weeks").click
      click_button "Continue"
      expect(page).to have_text("What was the length of the order?")

      fill_in "Number of weeks", with: "10"
      click_button "Continue"

      check_answers_and_go_to_results
    end
  end
end
