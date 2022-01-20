Feature: High level form markup smoke tests
  Scenario: Radio button form markup should be correct
    Given I have started a check
    When I visit "steps/check/kind"

    Then The form markup should match "steps_check_kind"
    Then The form markup with errors should match "steps_check_kind_with_errors"

  Scenario: Date form markup should be correct
    When I am in the conviction known date step

    Then The form markup should match "steps_conviction_known_date"
    Then The form markup with errors should match "steps_conviction_known_date_with_errors"
