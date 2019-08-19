Feature: Conviction
  Scenario Outline: Prevention and reparation order
  Given I am completing a basic 18 or over "Prevention and reparation order" conviction
  Then I should see "What type of order were you given?"

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
    | Attendance centre order                                        | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | What was the length of the order?                 | /steps/check/results |
    | Restraining order                                              | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | What was the length of the order?                 | /steps/check/results |
    | Sexual harm prevention order (sexual offence prevention order) | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | What was the length of the order?                 | /steps/check/results |
    | Supervision order                                              | When were you given the order?                 | Was the length of the order given in weeks, months or years?                 | What was the length of the order?                 | /steps/check/results |


  Scenario: Prevention and reparation order - Reparation order
  Given I am completing a basic 18 or over "Prevention and reparation order" conviction
  Then I should see "What type of order were you given?"

  When I choose "Reparation order"
  Then I should see "When were you given the order?"

  And I enter a valid date
  Then I should be on "/steps/check/results"
