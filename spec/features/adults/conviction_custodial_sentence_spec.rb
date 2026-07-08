require "rails_helper"

RSpec.feature "Conviction - Custody or hospital order", type: :feature do
  def start_custodial_conviction
    visit "/"
    find("label", exact_text: "Convicted").click
    click_button "Continue"
    find("label", exact_text: "18 or over").click
    click_button "Continue"
    fill_in "Day", with: "1"
    fill_in "Month", with: "1"
    fill_in "Year", with: "1999"
    click_button "Continue"
    find("label", exact_text: "Custody or hospital order").click
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

  ["Prison sentence", "Suspended prison sentence"].each do |subtype|
    scenario "Adult prison sentence - #{subtype}" do
      travel_to Date.new(2020, 7, 3) do
        start_custodial_conviction
        expect(page).to have_text("What sentence were you given?")

        find("label", exact_text: subtype).click
        click_button "Continue"
        expect(page).to have_text("When did the sentence start?")

        enter_date(1, 1, 2020)
        expect(page).to have_text("Was the length of the sentence given in days, weeks, months or years?")

        find("label", exact_text: "Months").click
        click_button "Continue"
        expect(page).to have_text("What was the length of the sentence?")
        expect(page).to have_text("If you got more than one sentence at the same time")

        fill_in "Number of months", with: "22"
        click_button "Continue"

        check_answers_and_go_to_results
        expect(page).to have_text("This conviction will be spent on 1 November 2025")
      end
    end
  end

  scenario "Adult hospital order with length" do
    start_custodial_conviction
    expect(page).to have_text("What sentence were you given?")

    find("label", exact_text: "Hospital order").click
    click_button "Continue"
    expect(page).to have_text("When were you given the order?")

    enter_date(1, 1, 1999)
    expect(page).to have_text("Was the length of the order given in days, weeks, months or years?")

    find("label", exact_text: "Years").click
    click_button "Continue"
    expect(page).to have_text("What was the length of the order?")
    expect(page).to have_text("If you got more than one sentence at the same time")

    fill_in "Number of years", with: "2"
    click_button "Continue"

    check_answers_and_go_to_results
  end

  [
    {
      length_type: "No length was given",
      result: "This conviction will be spent on 1 January 2022",
    },
    {
      length_type: "Until further order",
      result: "This conviction is not spent and will stay in place until another order is made to change or end it",
    },
  ].each do |row|
    scenario "Adult hospital order - #{row[:length_type]}" do
      travel_to Date.new(2020, 12, 15) do
        start_custodial_conviction
        expect(page).to have_text("What sentence were you given?")

        find("label", exact_text: "Hospital order").click
        click_button "Continue"
        expect(page).to have_text("When were you given the order?")

        enter_date(1, 1, 2020)
        expect(page).to have_text("Was the length of the order given in days, weeks, months or years?")

        find("label", exact_text: row[:length_type]).click
        click_button "Continue"

        check_answers_and_go_to_results
        expect(page).to have_text(row[:result])
      end
    end
  end

  scenario "Adult prison sentence - Schedule 18 offence" do
    travel_to Date.new(2020, 7, 3) do
      start_custodial_conviction
      expect(page).to have_text("What sentence were you given?")

      find("label", exact_text: "Prison sentence").click
      click_button "Continue"
      expect(page).to have_text("When did the sentence start")

      enter_date(1, 1, 2020)
      expect(page).to have_text("Was the length of the sentence given in days, weeks, months or years?")

      find("label", exact_text: "Years").click
      click_button "Continue"
      expect(page).to have_text("What was the length of the sentence?")

      fill_in "Number of years", with: "5"
      click_button "Continue"

      expect(page).to have_text("Were any of the offences specified in Schedule 18 of the sentencing code?")
      expect(page).to have_text("If you are unsure, please check the list of Schedule 18 offences here: Sentencing Act 2020 (legislation.gov.uk)")

      find("label", exact_text: "Yes").click
      click_button "Continue"
      expect(page).to have_text("Was more than one sentence given at the same time?")

      find("label", exact_text: "Yes").click
      click_button "Continue"
      expect(page).to have_text("Was a single sentence over 4 years?")

      find("label", exact_text: "Yes").click
      click_button "Continue"

      check_answers_and_go_to_results
      expect(page).to have_text("This conviction will never be spent")
    end
  end
end
