require "rails_helper"

RSpec.feature "Feedback Link in Banner", type: :feature do
  scenario "User sees and clicks the Feedback link in the banner" do
    visit root_path

    expect(page).to have_content("Help us make this service better. Give us your feedback.")
    expect(page).to have_link("feedback")
    click_link "feedback"
    expect(page).to have_current_path("https://www.smartsurvey.co.uk/s/FNZI5U/", url: true)
  end
end
