require "rails_helper"

RSpec.feature "Conviction - Motoring", type: :feature do
  before do
    visit "/"
    find("label", exact_text: "Convicted").click
    click_button "Continue"
    find("label", exact_text: "18 or over").click
    click_button "Continue"
    fill_in "Day", with: "1"
    fill_in "Month", with: "1"
    fill_in "Year", with: "1999"
    click_button "Continue"
    find("label", exact_text: "Motoring (including motoring fines)").click
    click_button "Continue"
  end

  def enter_date(day, month, year)
    fill_in "Day", with: day
    fill_in "Month", with: month
    fill_in "Year", with: year
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
    { length_months: "6",  spent_date: "This conviction was spent on 1 July 2020" },
    { length_months: "70", spent_date: "This conviction will be spent on 1 November 2025" },
  ].each do |row|
    scenario "Disqualification with #{row[:length_months]} months" do
      travel_to Date.new(2020, 7, 3) do
        find("label", exact_text: "Disqualification").click
        click_button "Continue"
        expect(page).to have_text("When did the ban start?")

        enter_date(1, 1, 2020)
        expect(page).to have_text("Was the length of the disqualification given in days, weeks, months or years?")

        find("label", exact_text: "Months").click
        click_button "Continue"
        expect(page).to have_text("What was the length of the disqualification?")

        fill_in "Number of months", with: row[:length_months]
        click_button "Continue"

        check_answers_and_go_to_results
        expect(page).to have_text(row[:spent_date])
      end
    end
  end

  [
    { length_option: "No length was given", spent_date: "This conviction was spent on 1 January 2020" },
    { length_option: "Until further order", spent_date: "This conviction is not spent and will stay in place until another order is made to change or end it" },
  ].each do |row|
    scenario "Disqualification - #{row[:length_option]}" do
      travel_to Date.new(2020, 7, 3) do
        find("label", exact_text: "Disqualification").click
        click_button "Continue"
        expect(page).to have_text("When did the ban start?")

        enter_date(1, 1, 2018)
        expect(page).to have_text("Was the length of the disqualification given in days, weeks, months or years?")

        find("label", exact_text: row[:length_option]).click
        click_button "Continue"

        check_answers_and_go_to_results
        expect(page).to have_text(row[:spent_date])
      end
    end
  end

  [
    { endorsement: "Yes", spent_date: "This conviction will be spent on 1 January 2025" },
    { endorsement: "No",  spent_date: "This conviction will be spent on 1 January 2021" },
  ].each do |row|
    scenario "Fine with endorsement: #{row[:endorsement]}" do
      travel_to Date.new(2020, 7, 3) do
        find("label", exact_text: "Fine").click
        click_button "Continue"
        expect(page).to have_text("Did you get an endorsement?")

        find("label", exact_text: row[:endorsement]).click
        click_button "Continue"
        expect(page).to have_text("When were you given the fine?")

        enter_date(1, 1, 2020)
        check_answers_and_go_to_results
        expect(page).to have_text(row[:spent_date])
      end
    end
  end

  scenario "Fixed Penalty notice (FPN) with endorsement" do
    travel_to Date.new(2020, 7, 3) do
      find("label", exact_text: "Fixed Penalty notice (FPN) with penalty points (endorsement)").click
      click_button "Continue"
      expect(page).to have_text("When was the endorsement given?")

      enter_date(1, 1, 2020)
      check_answers_and_go_to_results
      expect(page).to have_text("This conviction will be spent on 1 January 2025")
    end
  end

  scenario "Penalty points" do
    travel_to Date.new(2020, 7, 3) do
      find("label", exact_text: "Penalty points").click
      click_button "Continue"
      expect(page).to have_text("When were you given the penalty points?")

      enter_date(1, 1, 2020)
      check_answers_and_go_to_results
      expect(page).to have_text("This conviction will be spent on 1 January 2023")
    end
  end
end
