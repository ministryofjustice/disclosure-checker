Feature: Caution
  Background:
    When I visit "/"
    And I click the "Start now" link
    Then I should see "Were you cautioned or convicted?"

  @happy_path
  Scenario: Caution happy path - under 18, conditional caution
    When I choose "Cautioned"
    Then I should see "How old were you when you got cautioned?"

    And I choose "Under 18"
    Then I should see "What type of caution did you get?"

    And I choose "Youth conditional caution"

    Then I should see "When did you get the caution?"
    When I enter a valid date

    Then I should see "When did the conditions end?"
    When I enter a valid date

    Then I should see "Your caution was spent on 1 January 1999"

  @happy_path
  Scenario: Caution happy path - under 18, simple caution
    When I choose "Cautioned"
    Then I should see "How old were you when you got cautioned?"

    And I choose "Under 18"
    Then I should see "What type of caution did you get?"

    And I choose "Youth caution"

    Then I should see "When did you get the caution?"
    When I enter a valid date

    Then I should see "Your caution was spent on 1 January 1999"
