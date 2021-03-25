Feature: Conviction
  Background:
    When I am completing a basic under 18 "Financial penalty (not including motoring fines)" conviction

  @happy_path
  Scenario: Conviction Financial penalty - Fine
    When I choose "A fine"
    Then I should see "When were you given the order?"
    When I enter a valid date
    And I check my "conviction" answers and go to the results page

  @happy_path
  Scenario: Conviction Financial penalty - When compensation paid in full is over £100
    When I choose "Compensation to a victim"
    Then I should see "Have you paid the compensation in full?"
    And I choose "Yes"
    Then I should see "Was the compensation order amount over £100?"
    And I choose "Yes"
    Then I should see "When did you pay the compensation in full?"
    When I enter a valid date
    Then I should see "Did you send the payment receipt to the Disclosure and Barring (DBS) service?"
    And I choose "Yes"

    And I check my "conviction" answers and go to the results page

  @happy_path
  Scenario: Conviction Financial penalty - Compensation paid in full is under £100
    When I choose "Compensation to a victim"
    Then I should see "Have you paid the compensation in full?"
    And I choose "Yes"

    Then I should see "Was the compensation order amount over £100?"
    And I choose "No"

    Then I should see "When did you pay the compensation in full?"
    When I enter a valid date

    And I check my "conviction" answers and go to the results page

  @happy_path
  Scenario: Conviction Financial penalty - Did not send payment receipt
    When I choose "Compensation to a victim"
    Then I should see "Have you paid the compensation in full?"
    And I choose "Yes"

    Then I should see "Was the compensation order amount over £100?"
    And I choose "Yes"

    Then I should see "When did you pay the compensation in full?"
    When I enter a valid date

    Then I should see "Did you send the payment receipt to the Disclosure and Barring (DBS) service?"
    And I choose "No"

    Then I should be on "/steps/conviction/compensation_unable_to_tell"

  @happy_path
  Scenario: Conviction Financial penalty - Compensation not paid in full
    When I choose "Compensation to a victim"
    Then I should see "Have you paid the compensation in full?"
    And I choose "No"
    Then I should be on "/steps/conviction/compensation_not_paid"
