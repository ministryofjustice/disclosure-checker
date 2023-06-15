require "rails_helper"

class DummyStepController < StepController
  def show
    head(:ok)
  end

  def steps_check_check_your_answers_path
    "/steps/cya"
  end
end

RSpec.describe StepController, type: :controller do
  before do
    @controller = DummyStepController.new

    Rails.application.routes.draw do
      get "/dummy_step" => "dummy_step#show"
      root to: "dummy_root#index"
    end
  end

  after do
    Rails.application.reload_routes!
  end

  describe "navigation stack" do
    let!(:disclosure_check) { DisclosureCheck.create(navigation_stack:) }
    let(:params) { {} }

    before do
      get(:show, session: { disclosure_check_id: disclosure_check.id }, params:)
      disclosure_check.reload
    end

    context "when the stack is empty" do
      let(:navigation_stack) { [] }

      it "adds the page to the stack" do
        expect(disclosure_check.navigation_stack).to eq(["/dummy_step"])
      end
    end

    context "when the current page is on the stack" do
      let(:navigation_stack) { ["/foo", "/bar", "/dummy_step", "/baz"] }

      it "rewinds the stack to the appropriate point" do
        expect(disclosure_check.navigation_stack).to eq(["/foo", "/bar", "/dummy_step"])
      end
    end

    context "when the current page is not on the stack" do
      let(:navigation_stack) { ["/foo", "/bar", "/baz"] }

      it "adds it to the end of the stack" do
        expect(disclosure_check.navigation_stack).to eq(["/foo", "/bar", "/baz", "/dummy_step"])
      end
    end

    context "when coming from the check your answer page" do
      # NOTE: for the sake of this test we reuse the same record ID
      let(:params) { { check_id: disclosure_check.id } }
      let(:navigation_stack) { ["/foo", "/bar", "/baz"] }

      it "resets the stack starting in the CYA page and append the new page" do
        expect(disclosure_check.navigation_stack).to eq(["/steps/cya", "/dummy_step"])
      end
    end
  end

  describe "#previous_step_path" do
    let!(:disclosure_check) { DisclosureCheck.create(navigation_stack:) }

    before do
      get :show, session: { disclosure_check_id: disclosure_check.id }
    end

    context "when the stack is empty" do
      let(:navigation_stack) { [] }

      it "returns the root path" do
        expect(controller.previous_step_path).to eq("/")
      end
    end

    context "when the stack has elements" do
      let(:navigation_stack) { ["/somewhere", "/over", "/the", "/rainbow"] }

      it "returns the element before the current page" do
        # Not '/the', as we've performed a page load and thus added '/dummy_page' at the end
        expect(controller.previous_step_path).to eq("/rainbow")
      end
    end
  end

  # Note this method is private as it is used via another method but as the logic
  # is quite self contained it makes sense to test it in isolation.
  #
  describe "#normalise_date_attributes!" do
    let(:normalised_attributes) { controller.send(:normalise_date_attributes!, parameters) }
    let(:extra_parameters) { { foo: "bar", another: "attribute" } }

    context "when there are not multi param dates" do
      let(:parameters) { extra_parameters }

      it "returns the parameters as usual" do
        expect(
          normalised_attributes,
        ).to eq(extra_parameters)
      end
    end

    context "when there is a multi param date" do
      let(:parameters) do
        { "birth_date(1i)" => "2008", "birth_date(2i)" => "11", "birth_date(3i)" => "22" }.merge(extra_parameters)
      end

      it "converts the date parts to an array" do
        expect(
          normalised_attributes,
        ).to eq({ "birth_date" => [nil, 2008, 11, 22] }.merge(extra_parameters))
      end
    end

    context "when there is more than one multi param date and different part orders" do
      let(:parameters) do
        {
          "birth_date(1i)" => "2008", "birth_date(2i)" => "11", "birth_date(3i)" => "22"
        }.merge(
          "certification_date(3i)" => "25", "certification_date(2i)" => "12", "certification_date(1i)" => "2018",
        ).merge(extra_parameters)
      end

      it "converts the date parts to an array" do
        expect(
          normalised_attributes,
        ).to eq({ "birth_date" => [nil, 2008, 11, 22], "certification_date" => [nil, 2018, 12, 25] }.merge(extra_parameters))
      end
    end

    context "when some part of the date is missing or not a number" do
      let(:parameters) do
        { "birth_date(1i)" => "", "birth_date(2i)" => "foobar", "birth_date(3i)" => "22" }.merge(extra_parameters)
      end

      it "converts the date parts to an array" do
        expect(
          normalised_attributes,
        ).to eq({ "birth_date" => [nil, 0, 0, 22] }.merge(extra_parameters))
      end
    end
  end
end
