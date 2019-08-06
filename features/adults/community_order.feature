Feature: Conviction
  Scenario Outline: Community or youth rehabilitation order (YRO)
  Given I am completing a basic 18 or over "Community order" conviction
  Then I should see "What was your community order?"

  When I choose "<subtype>"
  Then I should see "<known_date_header>"

  And I enter a valid date
  Then I should see "<length_type_header>"

  And  I choose "Weeks"
  Then I should see "<length_header>"
  And I fill in "Number of weeks" with "10"

  Then I click the "Continue" button
  And I should be on "<result>"

  Examples:
    | subtype                                                        | known_date_header                              | length_type_header                                                           | length_header                                     | result               |
    | Alcohol abstinence or treatment                                | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | What was the length of the order?                 | /steps/check/results |
    | Behavioural change programme                                   | When were you given the programme?             | Was the length of the programme given in weeks, months or years?             | What was the length of the programme?             | /steps/check/results |
    | Curfew                                                         | When were you given the curfew?                | Was the length of the curfew given in weeks, months or years?                | What was the length of the curfew?                | /steps/check/results |
    | Drug rehabilitation, treatment or testing                      | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | What was the length of the order?                 | /steps/check/results |
    | Electronic monitoring requirement                              | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | What was the length of the order?                 | /steps/check/results |
    | Exclusion requirement                                          | When were you given the exclusion requirement? | Was the length of the exclusion requirement given in weeks, months or years? | What was the length of the exclusion requirement? | /steps/check/results |
    | Mental health treatment                                        | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | What was the length of the order?                 | /steps/check/results |
    | Prohibition                                                    | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | What was the length of the order?                 | /steps/check/results |
    | Rehabilitation activity requirement (RAR)                      | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | What was the length of the order?                 | /steps/check/results |
    | Residence requirement                                          | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | What was the length of the order?                 | /steps/check/results |
    | Unpaid work                                                    | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | What was the length of the order?                 | /steps/check/results |
