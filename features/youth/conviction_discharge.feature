Feature: Conviction
  Background:
    When I am completing a basic under 18 "Discharge" conviction
    Then I should see "What discharge were you given?"

  @happy_path
  Scenario: Conviction Discharge - Bind over
    And I choose "Bind over"
    Then I should see subsection "Bind over"
    And I should see "When were you given the order?"

    When I enter a valid date
    Then I should see "Was the length of the order given in days, weeks, months or years?"
    And I choose "Years"

    Then I should see "What was the length of the order?"
    And I fill in "Number of years" with "2"

    Then I click the "Continue" button
     And I check my "conviction" answers and go to the results page

  @happy_path
  Scenario: Conviction Discharge - Absolute discharge
    And I choose "Absolute discharge"
    Then I should see subsection "Absolute discharge"
    And I should see "When were you given the discharge?"

    When I enter a valid date
    And I check my "conviction" answers and go to the results page

  @happy_path
  Scenario: Conviction Discharge - Conditional discharge
    And I choose "Conditional discharge"
    Then I should see subsection "Conditional discharge"
    And I should see "When were you given the discharge?"

    When I enter a valid date
    Then I should see "Was the length of the conditions given in days, weeks, months or years?"
    And I choose "Years"

    Then I should see "What was the length of the discharge?"
    And I fill in "Number of years" with "2"

    Then I click the "Continue" button
     And I check my "conviction" answers and go to the results page
