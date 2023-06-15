RSpec.shared_examples "a decision tree" do
  context "when the step is invalid" do
    let(:step_params) { { ungueltig: { waschmaschine: "nein" } } }

    it "raises an error" do
      expect { subject.destination }.to raise_error(
        BaseDecisionTree::InvalidStep, "Invalid step '{:ungueltig=>{:waschmaschine=>\"nein\"}}'"
      )
    end
  end

  context "when `next_step` has been provided" do
    let(:next_step) { { controller: :another_step, action: :show } }

    it { is_expected.to have_destination(:another_step, :show) }
  end

  # The following are mutant killers and are expected to raise exceptions
  # as these are shared steps made totally generic to fit any given decision tree.
  # For concrete tests use the individual decision_tree specs.
  #
  context "when `next_step` has not been provided" do
    let(:step_params) { { my_test_step: "anything" } }

    context "when `as` has been provided will use it" do
      let(:as) { :another_name }

      it "raises an error" do
        expect { subject.destination }.to raise_error(BaseDecisionTree::InvalidStep, "Invalid step 'another_name'")
      end
    end

    context "when `as` has not been provided will take the step_name from the step_params" do
      it "raises an error" do
        expect { subject.destination }.to raise_error(BaseDecisionTree::InvalidStep, "Invalid step '{:my_test_step=>\"anything\"}'")
      end
    end
  end
end
