require "rails_helper"

RSpec.feature "Remove a caution or conviction", type: :feature do
  def choose_and_continue(text)
    find("label", exact_text: text).click
    click_button "Continue"
  end

  def enter_date(day, month, year)
    fill_in "Day", with: day
    fill_in "Month", with: month
    fill_in "Year", with: year
    click_button "Continue"
  end

  scenario "Remove all entries returns to the start" do
    visit "/"

    # Add youth caution
    choose_and_continue "Cautioned"
    choose_and_continue "Under 18"
    choose_and_continue "Youth caution"
    enter_date(1, 1, 2006)
    expect(page).to have_text("Check your answers")
    click_button "Add a caution or conviction"

    # Add adult fine
    choose_and_continue "Convicted"
    choose_and_continue "18 or over"
    enter_date(1, 6, 2008)
    choose_and_continue "Financial penalty (not including motoring fines)"
    choose_and_continue "A fine"
    enter_date(1, 6, 2008)
    expect(page).to have_text("Check your answers")

    # Remove first entry
    click_link "Remove", match: :first
    expect(page).to have_text("Are you sure you want to remove this check?")
    choose_and_continue "Yes"
    expect(page).to have_text("Check your answers")

    # Remove remaining entry
    click_link "Remove", match: :first
    expect(page).to have_text("Are you sure you want to remove this check?")
    choose_and_continue "Yes"

    expect(page).to have_text("Were you cautioned or convicted?")
  end
end
