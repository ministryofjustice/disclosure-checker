Feature: Notification banner functionality
  Scenario: The banner shows with a link on the homepage
    When I visit "/"
    Then I should see the notification banner

  Scenario: The banner does not show up when entering conviction details
    Given I am completing a basic 18 or over "Military" conviction
    Then I should not see the notification banner

  Scenario: The banner does not show up when entering caution details
    When I visit "/"
    And I choose "Cautioned"
    Then I should not see the notification banner

  Scenario: The banner shows on the check answers page
    When I visit "/"
    And I choose "Cautioned"
    And I choose "18 or over"
    And I choose "Simple caution"
    And I enter a valid date
    Then I should see the notification banner
