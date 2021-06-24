Feature: Conviction

  Scenario Outline: Prevention or reparation order
    Given I am completing a basic under 18 "Prevention or reparation order" conviction
    Then I should see "What type of order were you given?"

    When I choose "<subtype>"
    Then I should see "<known_date_header>"

    And I enter a valid date
    Then I should see "<length_type_header>"

    And  I choose "Weeks"
    Then I should see "<length_header>"
    And I fill in "Number of weeks" with "10"

    Then I click the "Continue" button
    And I check my "conviction" answers and go to the results page

    Examples:
      | subtype                 | known_date_header              | length_type_header                                           | length_header                          |
      | Restraining order       | When were you given the order? | Was the length of the order given in days, weeks, months or years? | What was the length of the order?      |
      | Sexual harm prevention order | When were you given the order? | Was the length of the order given in days, weeks, months or years? | What was the length of the order? |


  Scenario: Prevention or reparation order - Reparation order
    Given I am completing a basic under 18 "Prevention or reparation order" conviction
    Then I should see "What type of order were you given?"

    When I choose "Reparation order"
    Then I should see "When were you given the order?"

    And I enter a valid date
    And I check my "conviction" answers and go to the results page
