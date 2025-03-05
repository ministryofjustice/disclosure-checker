Feature: A person who made a mistake and wants to remove a caution or conviction

  Scenario: Simple Youth Caution and Adult Fine
    And I have started a check
    And I choose "Cautioned"
    And I choose "Under 18"
    And I choose "Youth caution"
    And I enter the following date 01-01-2006
   Then I should see "Check your answers"
    And I click the "Add a caution or conviction" button

   Then I choose "Convicted"
    And I choose "18 or over"
    And I enter the following date 01-06-2008
    And I choose "Financial penalty (not including motoring fines)"
    And I choose "A fine"
    And I enter the following date 01-06-2008

   Then I should see "Check your answers"
    And I click to remove the first sentence
   Then I should see "Are you sure you want to remove this check?"
    And I choose "Yes"
   Then I should see "Check your answers"
    And I click to remove the first sentence
   Then I should see "Are you sure you want to remove this check?"
    And I choose "Yes"
   Then I should see "Were you cautioned or convicted?"
