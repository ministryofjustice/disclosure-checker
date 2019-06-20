Feature: Conviction
  Background:
    When I am completing a basic under 18 "Financial penalty" conviction

  @happy_path
  Scenario: Conviction Financial penalty - Fine
    When I choose "A fine"
    Then I should see "When did you get convicted?"

    And I fill in "Day" with "1"
    And I fill in "Month" with "1"
    And I fill in "Year" with "1999"
    And I click the "Continue" button

  @happy_path
  Scenario: Conviction Financial penalty - Compensation paid in full
    When I choose "Compensation to a victim"
    Then I should see "Did you pay the compensation in full?"
    And I choose "Yes"

    Then I should see "When did you pay the compensation in full?"

    And I fill in "Day" with "1"
    And I fill in "Month" with "1"
    And I fill in "Year" with "1999"
    And I click the "Continue" button

  @happy_path
  Scenario: Conviction Financial penalty - Compensation not paid in full
    When I choose "Compensation to a victim"
    Then I should see "Did you pay the compensation in full?"
    And I choose "No"
