RSpec.describe ResultsItemPresenter do
  subject { described_class.build(disclosure_check, scope:) }

  let(:disclosure_check) { instance_double(DisclosureCheck, kind:) }
  let(:scope) { "foobar" }

  describe ".build" do
    context "for a caution" do
      let(:kind) { CheckKind::CAUTION }

      it "returns a `CautionResultPresenter` instance" do
        expect(subject).to be_an_instance_of(CautionResultPresenter)
      end
    end

    context "for a conviction" do
      let(:kind) { CheckKind::CONVICTION }

      it "returns a `ConvictionResultPresenter` instance" do
        expect(subject).to be_an_instance_of(ConvictionResultPresenter)
      end
    end

    context "for an unknown kind" do
      let(:kind) { "foobar" }

      it "raises an error" do
        expect { subject }.to raise_error(TypeError)
      end
    end
  end
end
