Feature: Conviction
  Background:
    When I am completing a basic under 18 "Financial penalty" conviction

  @happy_path
  Scenario: Conviction Financial penalty - Fine
    When I choose "A fine"
    Then I should see "When did you get convicted?"
    When I enter a valid date
    Then I should be on "/steps/check/results"

  @happy_path
  Scenario: Conviction Financial penalty - Compensation paid in full
    When I choose "Compensation to a victim"
    Then I should see "Did you pay the compensation in full?"
    And I choose "Yes"

    Then I should see "When did you pay the compensation in full?"

    When I enter a valid date
    Then I should be on "/steps/check/results"

  @happy_path
  Scenario: Conviction Financial penalty - Compensation not paid in full
    When I choose "Compensation to a victim"
    Then I should see "Did you pay the compensation in full?"
    And I choose "No"
    Then I should be on "/steps/check/exit_over18"
