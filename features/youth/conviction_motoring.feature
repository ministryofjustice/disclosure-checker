Feature: Youth Conviction
  Background:
    Given I am completing a basic under 18 "Motoring (including motoring fines)" conviction
    Then I should see "What was your motoring conviction?"

  @happy_path @date_travel
  Scenario Outline: Motoring disqualification with length
    Given The current date is 03-07-2020
    When I choose "<subtype>"

    Then I should see "<known_date_header>"
    And I enter the following date 01-01-2020

    Then I should see "<length_type_header>"
    And  I choose "Months"

    Then I should see "<length_header>"
    And I fill in "Number of months" with "<length_months>"
    And I click the "Continue" button

    And I check my "conviction" answers and go to the results page
    And I should see "<spent_date>"

    Examples:
      | subtype          | known_date_header       | length_type_header                                                      | length_header                                | length_months | spent_date                                   |
      | Disqualification | When did the ban start? | Was the length of the disqualification given in days, weeks, months or years? | What was the length of the disqualification? | 6             | This conviction was spent on 1 July 2020 |
      | Disqualification | When did the ban start? | Was the length of the disqualification given in days, weeks, months or years? | What was the length of the disqualification? | 40            | This conviction will be spent on 1 May 2023 |

  @happy_path @date_travel
  Scenario Outline: Motoring disqualification without length or indefinite
    Given The current date is 03-07-2020
    When I choose "<subtype>"

    Then I should see "<known_date_header>"
    And I enter the following date 01-01-2018

    Then I should see "<length_type_header>"
    And  I choose "<length_option>"

    And I check my "conviction" answers and go to the results page
    And I should see "<spent_date>"

    Examples:
      | subtype          | known_date_header       | length_type_header                                                            | length_option       | spent_date |
      | Disqualification | When did the ban start? | Was the length of the disqualification given in days, weeks, months or years? | No length was given | This conviction was spent on 1 January 2020 |
      | Disqualification | When did the ban start? | Was the length of the disqualification given in days, weeks, months or years? | Until further order | This conviction is not spent and will stay in place until another order is made to change or end it |

  @happy_path @date_travel
  Scenario Outline: Motoring fine
    Given The current date is 03-07-2020
    When I choose "<subtype>"

    Then I should see "Did you get an endorsement?"
    And I choose "<endorsement>"

    Then I should see "<known_date_header>"
    And I enter the following date 01-01-2020

    And I check my "conviction" answers and go to the results page
    And I should see "<spent_date>"

    Examples:
      | subtype | endorsement | known_date_header             | spent_date                                   |
      | Fine    | Yes         | When were you given the fine? | This conviction will be spent on 1 July 2022 |
      | Fine    | No          | When were you given the fine? | This conviction was spent on 1 July 2020     |

  @happy_path @date_travel
  Scenario: Motoring endorsed FPN
    Given The current date is 03-07-2020
    When I choose "Fixed Penalty notice (FPN) with penalty points (endorsement)"

    Then I should see "When was the endorsement given?"
    And I enter the following date 01-01-2020

    And I check my "conviction" answers and go to the results page
    And I should see "This conviction will be spent on 1 July 2022"

  @happy_path @date_travel
  Scenario: Motoring penalty points
    Given The current date is 03-07-2020
    When I choose "Penalty points"

    Then I should see "When were you given the penalty points?"
    And I enter the following date 01-01-2020

    And I check my "conviction" answers and go to the results page
    And I should see "This conviction will be spent on 1 January 2023"
