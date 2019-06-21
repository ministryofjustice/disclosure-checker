Feature: Conviction
  Background:
    When I am completing a basic under 18 "Hospital or guardianship order" conviction
    Then I should see "What type of order were you given?"

  @happy_path
  Scenario: Conviction Hospital or guardianship order - Hospital order
    And I choose "Hospital order"
    Then I should see "When did you get convicted?"

    When I enter a valid date

    Then I should see "Was the length of conviction given in weeks, months or years?"
    And I choose "Weeks"

    Then I should see "What was the length of the order?"
    And I fill in "What was the length of the order?" with "10"

  @happy_path
  Scenario: Conviction Hospital or guardianship order - Guardianship order
    And I choose "Guardianship order"
    Then I should see "When did you get convicted?"

    When I enter a valid date

    Then I should see "Was the length of conviction given in weeks, months or years?"
    And I choose "Weeks"

    Then I should see "What was the length of the order?"
    And I fill in "What was the length of the order?" with "10"
