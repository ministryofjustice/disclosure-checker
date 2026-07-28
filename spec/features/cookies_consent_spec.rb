require "rails_helper"

RSpec.feature "Cookies consent", type: :feature do
  before do
    visit "/"
  end

  scenario "User accepts analytics cookies" do
    expect(page).to have_text("Cookies on Check when to disclose cautions or convictions")
    expect(page).to have_link("View cookies", href: "/cookies")

    click_button "Accept analytics cookies"

    expect(page).to have_current_path("/steps/check/kind", ignore_query: true)
    expect(page).to have_text("You’ve accepted analytics cookies.")
    expect(page).to have_link("change your cookie settings", href: "/cookies")

    click_link "Hide this message"

    expect(page).to have_current_path("/steps/check/kind", ignore_query: true)
    expect(page).not_to have_text("You’ve accepted analytics cookies")
    expect(page).not_to have_text("Cookies on Check when to disclose cautions or convictions")
  end

  scenario "User rejects analytics cookies" do
    expect(page).to have_text("Cookies on Check when to disclose cautions or convictions")
    expect(page).to have_link("View cookies", href: "/cookies")

    click_button "Reject analytics cookies"

    expect(page).to have_current_path("/steps/check/kind", ignore_query: true)
    expect(page).to have_text("You’ve rejected analytics cookies.")
    expect(page).to have_link("change your cookie settings", href: "/cookies")

    click_link "Hide this message"

    expect(page).to have_current_path("/steps/check/kind", ignore_query: true)
    expect(page).not_to have_text("You’ve rejected analytics cookies")
    expect(page).not_to have_text("Cookies on Check when to disclose cautions or convictions")
  end

  scenario "Cookies page consent settings" do
    expect(page).to have_text("Cookies on Check when to disclose cautions or convictions")
    expect(page).to have_link("View cookies", href: "/cookies")

    click_link "View cookies"

    expect(page).to have_current_path("/cookies", ignore_query: true)
    expect(page).to have_text("Do you want to accept analytics cookies?")

    find("label", exact_text: "Yes").click
    click_button "Save cookie settings"

    expect(page).to have_text("You’ve set your cookie preferences.")
  end
end
