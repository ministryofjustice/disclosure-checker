Feature: A person with cautions and convictions

  @date_travel
  Scenario: Discharge Order and Community Order
    Given The current date is 28-04-2021
      And I have started a check
      And I choose "Cautioned"
      And I choose "Under 18"
      And I choose "Youth caution"
      And I enter the following date 01-01-2006
     Then I should see "Check your answers"
      # And I click the "Add a caution or conviction" button

      # And I choose "Convicted"
      # And I choose "Under 18"
      # And I enter the following date 01-06-2008
      # And I choose "Referral or youth rehabilitation order (YRO)"
      # And I choose "Referral order"
      # And I enter the following date 01-06-2008
      # And I choose "Years"
      # And I fill in "Number of years" with "2"
      # And I click the "Continue" button
     # Then I should see "Check your answers"
      # And I click the "Add a caution or conviction" button

      # And I choose "Convicted"
      # And I choose "18 or over"
      # And I enter the following date 25-01-2017
      # And I choose "Discharge"
      # And I choose "Conditional discharge"
      # And I enter the following date 25-01-2017
      # And I choose "Years"
      # And I fill in "Number of years" with "2"
     # Then I click the "Continue" button

      # And I should see "Check your answers"
      # And I should see "Conviction 1"
      # And I should see "Conditional discharge"
      # And I should see the button "Add another sentence"
      # And I should see the button "Add a caution or conviction"

      # And I click the "Add a caution or conviction" button

      # And I choose "Convicted"
      # And I choose "18 or over"
      # And I enter the following date 10-12-2018
      # And I choose "Community, reparation or other order with requirements"
      # And I choose "Community order"
      # And I enter the following date 10-12-2018
      # And I choose "Months"
      # And I fill in "Number of months" with "12"
     # Then I click the "Continue" button
      # And I should see "Check your answers"

     # Check in progress warning quick smoke test
     When I click the "Check when to disclose cautions or convictions" link
     Then I should see "This tool is being updated"
     When I click "Continue" link
     Then I should see "It looks like you already have a check in progress"
      And I should see a "Resume check" link to "/steps/check/check_your_answers"
      And I should see a "Start a new check" link to "/?new=y"
     When I click the "Resume check" link
     Then I should see "Check your answers"

     Then I click the "Continue to your results" button

      And I should see "Caution 1"
      And I should see "This caution is spent on the day you receive it"
      And I should see "Youth caution"

      # And I should see "Conviction 1"
      # And I should see "This conviction was spent on 1 June 2010"
      # And I should see "Referral order"

      # And I should see "Conviction 2"
      # And I should see "This conviction was spent on 10 December 2019"
      # And I should see "Conditional discharge"

      # And I should see "Conviction 3"
      # And I should see "This conviction was spent on 10 December 2019"
      # And I should see "Community order"
