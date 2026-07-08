require "rails_helper"

RSpec.feature "Notification banner", type: :feature do
  def expect_notification_banner
    aggregate_failures do
      expect(page).to have_text("New legislative changes to rehabilitation periods came into effect")
      expect(page).to have_link("rehabilitation periods", href: "https://www.gov.uk/guidance/rehabilitation-periods")
    end
    alias_method :have_notification_banner, :expect_notification_banner
  end

  scenario "Banner shows on the kind (start) page" do
    visit "/"
    have_notification_banner
  end

  scenario "Banner does not show when entering conviction details" do
    visit "/"
    find("label", exact_text: "Convicted").click
    click_button "Continue"
    find("label", exact_text: "18 or over").click
    click_button "Continue"
    fill_in "Day", with: "1"
    fill_in "Month", with: "1"
    fill_in "Year", with: "1999"
    click_button "Continue"
    find("label", exact_text: "Military").click
    click_button "Continue"

    expect(page).not_to have_text("New legislative changes to rehabilitation periods came into effect")
  end

  scenario "Banner does not show when entering caution details" do
    visit "/"
    find("label", exact_text: "Cautioned").click
    click_button "Continue"

    expect(page).not_to have_text("New legislative changes to rehabilitation periods came into effect")
  end

  scenario "Banner shows on the check answers page" do
    visit "/"
    find("label", exact_text: "Cautioned").click
    click_button "Continue"
    find("label", exact_text: "18 or over").click
    click_button "Continue"
    find("label", exact_text: "Simple caution").click
    click_button "Continue"
    fill_in "Day", with: "1"
    fill_in "Month", with: "1"
    fill_in "Year", with: "1999"
    click_button "Continue"

    have_notification_banner
  end
end
