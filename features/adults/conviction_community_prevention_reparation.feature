Feature: Conviction

  Scenario Outline: Adult community, reparation or other order with requirements
    Given I am completing a basic 18 or over "Community, reparation or other order with requirements" conviction
    Then I should see "What was your community, reparation or other order with requirements?"

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
      | subtype                        | known_date_header              | length_type_header                                           | length_header                     |
      | Attendance centre order        | When were you given the order? | Was the length of the order given in weeks, months or years? | What was the length of the order? |
      | Community order                | When were you given the order? | Was the length of the order given in weeks, months or years? | What was the length of the order? |
      | Criminal behaviour order       | When were you given the order? | Was the length of the order given in weeks, months or years? | What was the length of the order? |
      | Restraining order              | When were you given the order? | Was the length of the order given in weeks, months or years? | What was the length of the order? |
      | Serious crime prevention order | When were you given the order? | Was the length of the order given in weeks, months or years? | What was the length of the order? |
      | Sexual harm prevention order   | When were you given the order? | Was the length of the order given in weeks, months or years? | What was the length of the order? |
      | Any other order with a requirement | When were you given the order? | Was the length of the order given in weeks, months or years? | What was the length of the order? |

  Scenario: Adult community, reparation or other order with requirements - Reparation order
    Given I am completing a basic 18 or over "Community, reparation or other order with requirements" conviction
    Then I should see "What was your community, reparation or other order with requirements?"

    When I choose "Reparation order"
    Then I should see "When were you given the order?"

    And I enter a valid date
    And I check my "conviction" answers and go to the results page
