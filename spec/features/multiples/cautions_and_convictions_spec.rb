require "rails_helper"

RSpec.feature "Multiple cautions and convictions", type: :feature do
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

  scenario "Discharge order and community order with multiple convictions" do
    travel_to Date.new(2021, 4, 28) do
      visit "/"

      # Caution 1: youth caution
      choose_and_continue "Cautioned"
      choose_and_continue "Under 18"
      choose_and_continue "Youth caution"
      enter_date(1, 1, 2006)
      expect(page).to have_text("Check your answers")
      click_button "Add a caution or conviction"

      # Conviction 1: referral order
      choose_and_continue "Convicted"
      choose_and_continue "Under 18"
      enter_date(1, 6, 2008)
      choose_and_continue "Referral or youth rehabilitation order (YRO)"
      choose_and_continue "Referral order"
      enter_date(1, 6, 2008)
      choose_and_continue "Years"
      fill_in "Number of years", with: "2"
      click_button "Continue"
      expect(page).to have_text("Check your answers")
      click_button "Add a caution or conviction"

      # Conviction 2: conditional discharge
      choose_and_continue "Convicted"
      choose_and_continue "18 or over"
      enter_date(25, 1, 2017)
      choose_and_continue "Discharge"
      choose_and_continue "Conditional discharge"
      enter_date(25, 1, 2017)
      choose_and_continue "Years"
      fill_in "Number of years", with: "2"
      click_button "Continue"
      expect(page).to have_text("Check your answers")
      expect(page).to have_text("Conviction 1")
      expect(page).to have_text("Conditional discharge")
      expect(page).to have_button("Add another sentence")
      expect(page).to have_button("Add a caution or conviction")
      click_button "Add a caution or conviction"

      # Conviction 3: community order
      choose_and_continue "Convicted"
      choose_and_continue "18 or over"
      enter_date(10, 12, 2018)
      choose_and_continue "Community, reparation or other order with requirements"
      choose_and_continue "Community order"
      enter_date(10, 12, 2018)
      choose_and_continue "Months"
      fill_in "Number of months", with: "12"
      click_button "Continue"
      expect(page).to have_text("Check your answers")

      # In-progress warning smoke test
      click_link "Check when to disclose cautions or convictions"
      expect(page).to have_text("It looks like you already have a check in progress")
      expect(page).to have_link("Resume check", href: "/steps/check/check_your_answers")
      expect(page).to have_link("Start a new check", href: "/?new=y")
      click_link "Resume check"
      expect(page).to have_text("Check your answers")

      click_button "Continue to your results"

      expect(page).to have_text("Caution 1")
      expect(page).to have_text("This caution is spent on the day you receive it")
      expect(page).to have_text("Youth caution")

      expect(page).to have_text("Conviction 1")
      expect(page).to have_text("This conviction was spent on 1 June 2010")
      expect(page).to have_text("Referral order")

      expect(page).to have_text("Conviction 2")
      expect(page).to have_text("This conviction was spent on 10 December 2019")
      expect(page).to have_text("Conditional discharge")

      expect(page).to have_text("Conviction 3")
      expect(page).to have_text("This conviction was spent on 10 December 2019")
      expect(page).to have_text("Community order")
    end
  end
end
