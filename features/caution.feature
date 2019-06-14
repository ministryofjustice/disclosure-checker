Feature: Caution
  Background:
    When I visit "/"
    Then I should see "Check if you need to disclose your criminal record"
    And I click the "Start now" link
    Then I should see "Were you cautioned or convicted?"

  @happy_path
  Scenario: Over 18
    When I choose "Caution"
    Then I should see "How old were you when you got cautioned?"
    And I choose "18 or over"
    Then I should see "Sorry, you cannot use this service yet"

  @happy_path
  Scenario: Caution happy path - under 18, conditional caution
    When I choose "Caution"
    Then I should see "How old were you when you got cautioned?"

    And I choose "Under 18"
    Then I should see "What type of caution did you get?"

    And I choose "Conditional caution"

    Then I should see "Did you stick to the conditions of the caution?"

    And I choose "Yes"

    Then I should see "When did the conditions end?"

    And I fill in "Day" with "1"
    And I fill in "Month" with "1"
    And I fill in "Year" with "1999"
    And I click the "Continue" button

    Then I should see "Your caution expired on 01 January 1999"


  @happy_path
  Scenario: Caution happy path - under 18, simple caution
    When I choose "Caution"
    Then I should see "How old were you when you got cautioned?"
    And I choose "Under 18"
    Then I should see "What type of caution did you get?"

    And I choose "Youth caution"

    Then I should see "When did you get the caution?"

    And I fill in "Day" with "1"
    And I fill in "Month" with "1"
    And I fill in "Year" with "1999"
    And I click the "Continue" button

    Then I should see "Your caution expired on 01 January 1999"

    # TODO: to be continued...
