Feature: Conviction
  Scenario Outline: Community or youth rehabilitation order (YRO)
  Given I am completing a basic under 18 "Community or youth rehabilitation order (YRO)" conviction
  Then I should see "What was your community or youth rehabilitation order (YRO)?"

  When I choose "<subtype>"
  Then I should see "<known_date_header>"

  When I enter a valid date
  Then I should see "<length_type_header>"
  And  I choose "Weeks"
  Then I should see "What was the length of the order?"
  And I fill in "What was the length of the order?" with "10"
  Then I click the "Continue" button
  Then I should be on "<result>"

  Examples:
    | subtype                                                        | known_date_header                              | length_type_header                                                           | result               |
    | Alcohol abstinence or treatment                                | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | /steps/check/results |
    | Attendance centre order                                        | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | /steps/check/results |
    | Behavioural change programme                                   | When were you given the programme?             | Was the length of the programme given in weeks, months or years?             | /steps/check/results |
    | Curfew                                                         | When were you given the curfew?                | Was the length of the curfew given in weeks, months or years?                | /steps/check/results |
    | Drug rehabilitation, treatment or testing                      | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | /steps/check/results |
    | Exclusion requirement                                          | When were you given the exclusion requirement? | Was the length of the exclusion requirement given in weeks, months or years? | /steps/check/results |
    | Intoxicating substance treatment requirement                   | When were you given the treatment?             | Was the length of the treatment given in weeks, months or years?             | /steps/check/results |
    | Mental health treatment                                        | When were you given the treatment?             | Was the length of the treatment given in weeks, months or years?             | /steps/check/results |
    | Prohibition                                                    | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | /steps/check/results |
    | Referral order                                                 | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | /steps/check/results |
    | Rehabilitation activity requirement (RAR)                      | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | /steps/check/results |
    | Reparation order                                               | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | /steps/check/results |
    | Residence requirement                                          | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | /steps/check/results |
    | Sexual harm prevention order (sexual offence prevention order) | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | /steps/check/results |
    | Supervision order on breach of a civil injunction              | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | /steps/check/results |
    | Unpaid work                                                    | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | /steps/check/results |
