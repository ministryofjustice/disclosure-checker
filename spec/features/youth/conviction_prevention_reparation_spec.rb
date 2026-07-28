require "rails_helper"

RSpec.feature "Conviction - Youth prevention or reparation order", type: :feature do
  def start_prevention_reparation_conviction
    visit "/"
    find("label", exact_text: "Convicted").click
    click_button "Continue"
    find("label", exact_text: "Under 18").click
    click_button "Continue"
    fill_in "Day", with: "1"
    fill_in "Month", with: "1"
    fill_in "Year", with: "1999"
    click_button "Continue"
    find("label", exact_text: "Prevention or reparation order").click
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

  ["Restraining order", "Sexual harm prevention order"].each do |subtype|
    scenario "Prevention order - #{subtype}" do
      start_prevention_reparation_conviction
      expect(page).to have_text("What type of order were you given?")

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

  scenario "Reparation order" do
    start_prevention_reparation_conviction
    expect(page).to have_text("What type of order were you given?")

    find("label", exact_text: "Reparation order").click
    click_button "Continue"
    expect(page).to have_text("When were you given the order?")

    enter_valid_date

    check_answers_and_go_to_results
  end
end
