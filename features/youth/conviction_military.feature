Feature: Conviction

  @happy_path
  Scenario Outline: Military convictions with length
    Given I am completing a basic under 18 "Military" conviction
    Then I should see "What was your military conviction?"

    When I choose "<subtype>"
    Then I should see "<known_date_header>"

    And I enter a valid date
    Then I should see "<length_type_header>"

    And  I choose "Years"
    Then I should see "<length_header>"
    And I fill in "Number of years" with "5"

    Then I click the "Continue" button
    And I check my "conviction" answers and go to the results page

    Examples:
      | subtype                  | length_type_header                                               | known_date_header                  | length_header                         |
      | Overseas community order | Was the length of the order given in weeks, months or years?     | When were you given the order?     | What was the length of the order?     |
      | Service community order  | Was the length of the order given in weeks, months or years?     | When were you given the order?     | What was the length of the order?     |
      | Service detention        | Was the length of the detention given in weeks, months or years? | When were you given the detention? | What was the length of the detention? |

  @happy_path
  Scenario Outline: Military convictions without length
    Given I am completing a basic under 18 "Military" conviction
    Then I should see "What was your military conviction?"

    When I choose "<subtype>"
    Then I should see "<known_date_header>"

    And I enter a valid date
    And I check my "conviction" answers and go to the results page

    Examples:
      | subtype   | known_date_header                  |
      | Dismissal | When were you given the dismissal? |
