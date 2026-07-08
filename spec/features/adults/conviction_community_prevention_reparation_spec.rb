require "rails_helper"

RSpec.feature "Conviction - Community, reparation or other order with requirements", type: :feature do
  def start_community_reparation_conviction
    visit "/"
    find("label", exact_text: "Convicted").click
    click_button "Continue"
    find("label", exact_text: "18 or over").click
    click_button "Continue"
    fill_in "Day", with: "1"
    fill_in "Month", with: "1"
    fill_in "Year", with: "1999"
    click_button "Continue"
    find("label", exact_text: "Community, reparation or other order with requirements").click
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
    "Attendance centre order",
    "Community order",
    "Criminal behaviour order",
    "Restraining order",
    "Serious crime prevention order",
    "Sexual harm prevention order",
    "Any other order with a requirement",
  ].each do |subtype|
    scenario "Adult with #{subtype}" do
      start_community_reparation_conviction
      expect(page).to have_text("What was your community, reparation or other order with requirements?")

      find("label", exact_text: subtype).click
      click_button "Continue"
      expect(page).to have_text("When were you given the order?")

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

  scenario "Adult with Reparation order" do
    start_community_reparation_conviction
    expect(page).to have_text("What was your community, reparation or other order with requirements?")

    find("label", exact_text: "Reparation order").click
    click_button "Continue"
    expect(page).to have_text("When were you given the order?")

    enter_valid_date

    check_answers_and_go_to_results
  end
end
