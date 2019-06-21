Feature: Conviction
  Background:
    When I am completing a basic under 18 "Discharge" conviction
    Then I should see "What discharge were you given?"

  @happy_path
  Scenario: Conviction Discharge - Absolute discharge
    And I choose "Absolute discharge"
    Then I should see "When did you get convicted?"
    When I enter a valid date
    Then I should be on "/steps/check/results"

  @happy_path
  Scenario: Conviction Discharge - Conditional discharge
    And I choose "Conditional discharge"
    Then I should see "When did you get convicted?"
    When I enter a valid date

    Then I should see "Was the length of conviction given in weeks, months or years?"
    And I choose "Weeks"
    Then I enter a conviction length in "weeks"
    Then I should be on "/steps/check/results"

