Feature: Conviction

  @happy_path
  Scenario Outline: Motoring convictions with length
    Given I am completing a basic 18 or over "Motoring" conviction
    Then I should see "What was your motoring conviction?"

    When I choose "<subtype>"
    Then I should see "Did you get an endorsement?"

    And I choose "Yes"
    Then I should see "<known_date_header>"

    And I enter a valid date
    Then I should see "<motoring_disqualification_end_date_header>"

    And I enter a valid date
    Then I should be on "<result>"

    Examples:
      | subtype           | known_date_header                         | motoring_disqualification_end_date_header | result               |
      | Disqualification  | When were you given the disqualification? | When did your disqualification end?       | /steps/check/results |

  @happy_path
  Scenario Outline: Motoring convictions without length
    Given I am completing a basic 18 or over "Motoring" conviction
    Then I should see "What was your motoring conviction?"

    When I choose "<subtype>"
    Then I should see "Did you get an endorsement?"

    And I choose "Yes"
    Then I should see "<known_date_header>"

    And I enter a valid date
    Then I should be on "<result>"

    Examples:
      | subtype                    | known_date_header                            | result               |
      | Fine                       | When were you given the fine?                | /steps/check/results |
      | Fixed Penalty notice (FPN) | When were you given the fixed notice points? | /steps/check/results |
      | Penalty points             | When were you given the penalty points?      | /steps/check/results |
