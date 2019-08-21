Feature: Conviction
  Scenario Outline: Prison sentence or hospital order
  When I am completing a basic 18 or over "Custody or hospital order" conviction
  Then I should see "What sentence were you given?"

  When I choose "<subtype>"
  Then I should see "<known_date_header>"

  And I enter a valid date
  Then I should see "<length_type_header>"

  And  I choose "Years"
  Then I should see "<length_header>"
  And I fill in "Number of years" with "2"

  Then I click the "Continue" button
  And I should be on "<result>"

  Examples:
    | subtype                   | known_date_header                   | length_type_header                                                   | length_header                          | result               |
    | Prison sentence           | When were you given the sentence?   | Was the length of the sentence given in weeks, months or years?      | What was the length of the sentence?   | /steps/check/results |
    | Suspended prison sentence | When were you given the sentence?   | Was the length of the sentence given in weeks, months or years?      | What was the length of the sentence?   | /steps/check/results |
    | Hospital order            | When were you given the order?      | Was the length of the order given in weeks, months or years?         | What was the length of the order?      | /steps/check/results |
