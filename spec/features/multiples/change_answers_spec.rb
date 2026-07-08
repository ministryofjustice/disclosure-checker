require "rails_helper"

RSpec.feature "Change answers", type: :feature do
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

  before do
    visit "/"
    choose_and_continue "Convicted"
    choose_and_continue "18 or over"
    enter_date(1, 1, 1999)
    choose_and_continue "Discharge"
    choose_and_continue "Bind over"
    enter_date(1, 6, 2000)
    choose_and_continue "Years"
    fill_in "Number of years", with: "2"
    click_button "Continue"
  end

  scenario "Change start date and length of sentence" do
    expect(page).to have_text("Check your answers")
    expect(page).to have_text("Conviction 1")
    expect(page).to have_text("1 June 2000")
    expect(page).to have_text("2 years")

    click_link "Change start date"
    expect(page).to have_text("When were you given the order?")
    enter_date(5, 8, 2001)

    expect(page).to have_text("Check your answers")
    expect(page).to have_text("5 August 2001")

    click_link "Change length of sentence"
    expect(page).to have_text("Was the length of the order given in days, weeks, months or years?")
    choose_and_continue "Months"
    fill_in "Number of months", with: "15"
    click_button "Continue"

    expect(page).to have_text("Check your answers")
    expect(page).to have_text("15 months")
  end
end
