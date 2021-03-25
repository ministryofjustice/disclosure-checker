Feature: Caution
  Background:
    When I visit "/"
    Then I should see "Were you cautioned or convicted?"
    When I choose "Cautioned"
    Then I should see "How old were you when you got cautioned?"
    And I choose "Under 18"
    Then I should see "What type of caution did you get?"

  @happy_path
  Scenario: Under 18, simple caution
    And I choose "Youth caution"

    Then I should see "When did you get the caution?"
    When I enter a valid date

     And I check my "caution" answers and go to the results page
    Then I should see "This caution is spent on the day you receive it"

  @happy_path
  Scenario: Under 18, conditional caution
    And I choose "Youth conditional caution"

    Then I should see "When did you get the caution?"
    When I enter a valid date

    Then I should see "When did the conditions end?"
    When I enter a valid date

     And I check my "caution" answers and go to the results page
    Then I should see "This caution was spent on 1 January 1999"
