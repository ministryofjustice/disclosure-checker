Feature: Conviction

  @happy_path
  Scenario Outline: Motoring convictions with length
    Given I am completing a basic 18 or over "Motoring" conviction
    Then I should see "What was your motoring conviction?"

    When I choose "<subtype>"
    Then I should see "<known_date_header>"

    And I enter a valid date
    Then I should see "<length_type_header>"

    And  I choose "Years"
    Then I should see "<length_header>"
    And I fill in "Number of years" with "5"

    Then I click the "Continue" button
    And I should be on "<result>"

    Examples:
      | subtype                        | known_date_header                         | length_type_header                                                      | length_header                                | result               |
      | Disqualification (driving ban) | When were you given the disqualification? | Was the length of the disqualification given in weeks, months or years? | What was the length of the disqualification? | /steps/check/results |

  @happy_path
  Scenario Outline: Motoring convictions without length
    Given I am completing a basic 18 or over "Motoring" conviction
    Then I should see "What was your motoring conviction?"

    When I choose "<subtype>"
    Then I should see "<known_date_header>"

    And I enter a valid date
    Then I should be on "<result>"

    Examples:
      | subtype        | known_date_header                       | result               |
      | Endorsement    | When were you given the endorsement?    | /steps/check/results |
      | Penalty points | When were you given the penalty points? | /steps/check/results |
