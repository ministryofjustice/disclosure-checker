Feature: Conviction
  Background:
    When I am completing a basic under 18 "Custodial sentence" conviction
    Then I should see "What was your custodial sentence?"

  @happy_path
  Scenario: Conviction Custodial sentence - Detention and training order
    And I choose "Detention and training order"
    Then I should see "When did you get convicted?"

    And I fill in "Day" with "1"
    And I fill in "Month" with "1"
    And I fill in "Year" with "1999"
    And I click the "Continue" button

    Then I should see "Was the length of conviction given in weeks, months or years?"
    And I choose "Weeks"

    Then I should see "Enter length of conviction given in weeks or months?"
    And I fill in "Length of conviction" with "10"

  @happy_path
  Scenario: Conviction Custodial sentence - Detention
    And I choose "A Detention"
    Then I should see "When did you get convicted?"

    And I fill in "Day" with "1"
    And I fill in "Month" with "1"
    And I fill in "Year" with "1999"
    And I click the "Continue" button

    Then I should see "Was the length of conviction given in weeks, months or years?"
    And I choose "Weeks"

    Then I should see "Enter length of conviction given in weeks or months?"
    And I fill in "Length of conviction" with "10"
