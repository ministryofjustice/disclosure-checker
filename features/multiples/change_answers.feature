Feature: A person who made a mistake and wants to change their answers
  Background:
    When I am completing a basic 18 or over "Discharge" conviction
     And I choose "Bind over"
     And I enter the following date 01-06-2000
     And I choose "Years"
     And I fill in "Number of years" with "2"
     And I click the "Continue" button

  Scenario: Change some answers of the conviction
    Then I should see "Check your answers"
     And I should see "Conviction 1"
     And I should see "1 June 2000"
     And I should see "2 years"

    When I click the "Change start date" link
    Then I should see "When were you given the order?"
     And I enter the following date 5-08-2001
    Then I should see "Check your answers"
     And I should see "5 August 2001"

    When I click the "Change length of sentence" link
    Then I should see "Was the length of the order given in days, weeks, months or years?"
     And I choose "Months"
     And I fill in "Number of months" with "15"
     And I click the "Continue" button
    Then I should see "Check your answers"
     And I should see "15 months"
