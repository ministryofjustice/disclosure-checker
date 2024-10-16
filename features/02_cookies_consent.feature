Feature: Cookies consent functionality
  Background:
    When I visit "/"
    Then I should see "Cookies on Check when to disclose cautions or convictions"
     And I should see a "View cookies" link to "/cookies"

  Scenario: The banner shows and user accepts it
    When I click the "Accept analytics cookies" button
    Then I should be on "/steps/check/kind"
     And I should see "You’ve accepted analytics cookies."
     And I should see a "change your cookie settings" link to "/cookies"
    When I click the "Hide this message" link
    Then I should be on "/steps/check/kind"
     And I should not see "You’ve accepted analytics cookies"
     And I should not see "Cookies on Check when to disclose cautions or convictions"

  Scenario: The banner shows and user rejects it
    When I click the "Reject analytics cookies" button
    Then I should be on "/steps/check/kind"
     And I should see "You’ve rejected analytics cookies."
     And I should see a "change your cookie settings" link to "/cookies"
    When I click the "Hide this message" link
    Then I should be on "/steps/check/kind"
     And I should not see "You’ve rejected analytics cookies"
     And I should not see "Cookies on Check when to disclose cautions or convictions"

  Scenario: Cookies page consent settings
    When I click the "View cookies" link
    Then I should be on "/cookies"
     And I should see "Do you want to accept analytics cookies?"
    When I click the radio button "Yes"
     And I click the "Save cookie settings" button
    Then I should see "You’ve set your cookie preferences."
