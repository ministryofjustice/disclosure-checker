require "rails_helper"

RSpec.feature "Conviction - Youth financial penalty", type: :feature do
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
    find("label", exact_text: "Financial penalty (not including motoring fines)").click
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

  scenario "Fine" do
    find("label", exact_text: "A fine").click
    click_button "Continue"

    expect(page).to have_text("When were you given the order?")
    enter_valid_date

    check_answers_and_go_to_results
  end

  scenario "Compensation to a victim - paid in full" do
    find("label", exact_text: "Compensation to a victim").click
    click_button "Continue"

    expect(page).to have_text("Have you paid the compensation in full?")
    find("label", exact_text: "Yes").click
    click_button "Continue"

    expect(page).to have_text("When did you pay the compensation in full?")
    enter_valid_date

    check_answers_and_go_to_results
  end

  scenario "Compensation to a victim - not paid in full" do
    find("label", exact_text: "Compensation to a victim").click
    click_button "Continue"

    expect(page).to have_text("Have you paid the compensation in full?")
    find("label", exact_text: "No").click
    click_button "Continue"

    expect(page).to have_current_path("/steps/conviction/compensation_not_paid", ignore_query: true)
  end
end
