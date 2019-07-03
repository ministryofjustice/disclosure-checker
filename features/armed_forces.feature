 Feature: Conviction
  Scenario Outline: Armed forces
  Given I am completing a basic under 18 "Armed forces" conviction
  Then I should see "What type of order were you given?"

  When I choose "<subtype>"
  Then I should see "<known_date_header>"

  And I enter a valid date
  Then I should be on "<result>"

 Examples:
    | subtype                   | known_date_header                   | result               |
    | Dismissal                 | When were you given the dismissal?  | /steps/check/results |
    | Service detention         | When were you given the detention?  | /steps/check/results |
    | Service community order   | When were you given the order?      | /steps/check/results |
    | Overseas community order  | When were you given the order?      | /steps/check/results |
