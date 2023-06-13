require "rspec/expectations"

RSpec::Matchers.define :have_destination do |controller, action, params = {}|
  match do |decision_tree|
    decision_tree.destination[:controller] == controller &&
      decision_tree.destination[:action] == action &&
      params.keys.all? { |key| decision_tree.destination[key].to_s == params[key].to_s }
  end

  failure_message do |decision_tree|
    "expected decision tree destination to be an appropriately formatted hash, got '#{decision_tree.destination}'"
  end
end

RSpec::Matchers.define :show_check_your_answers_page do
  match do |decision_tree|
    expect(decision_tree.disclosure_check).to receive(:completed!)

    destination = decision_tree.destination
    destination[:controller] == "/steps/check/check_your_answers" && destination[:action] == :show
  end

  failure_message do |decision_tree|
    "expected decision tree destination to be Check Your Answers, got '#{decision_tree.destination}'"
  end
end
