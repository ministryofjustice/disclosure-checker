Feature: Conviction
  Background:
    When I am completing a basic under 18 "Hospital or guardianship order" conviction
    Then I should see "What type of order were you given?"

  @happy_path
  Scenario: Conviction Hospital or guardianship order - Hospital order
    And I choose "Hospital order"
    Then I should see "When did you get convicted?"

    And I fill in "Day" with "1"
    And I fill in "Month" with "1"
    And I fill in "Year" with "1999"
    And I click the "Continue" button

    Then I should see "Was the length of conviction given in weeks, months or years?"
    And I choose "Weeks"

    Then I should see "Enter length of conviction given in weeks or months?"
    And I fill in "Length of conviction" with "10"

  @happy_path
  Scenario: Conviction Hospital or guardianship order - Guardianship order
    And I choose "Guardianship order"
    Then I should see "When did you get convicted?"

    And I fill in "Day" with "1"
    And I fill in "Month" with "1"
    And I fill in "Year" with "1999"
    And I click the "Continue" button

    Then I should see "Was the length of conviction given in weeks, months or years?"
    And I choose "Weeks"

    Then I should see "Enter length of conviction given in weeks or months?"
    And I fill in "Length of conviction" with "10"

