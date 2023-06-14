require "rails_helper"

# Please refer to any of the graphs we have in the folder docs/results/
#  They have been added to aid understanding how the rules for convictions work

# rubocop:disable RSpec/SubjectStub
RSpec.describe Calculators::Multiples::MultipleOffensesCalculator do
  subject(:calculator) { described_class.new(disclosure_report) }

  let(:disclosure_report) { instance_double(DisclosureReport, check_groups: groups_result_set, completed?: true) }
  let(:groups_result_set) { verifying_double("groups_result_set", with_completed_checks: [check_group1, check_group2]) }

  let(:check_group1) { instance_double(CheckGroup, disclosure_checks: [disclosure_check1, disclosure_check2]) }
  let(:check_group2) { instance_double(CheckGroup, disclosure_checks: [disclosure_check3]) }

  let(:disclosure_check1) { instance_double(DisclosureCheck, kind: "conviction") }
  let(:disclosure_check2) { instance_double(DisclosureCheck, kind: "conviction") }
  let(:disclosure_check3) { instance_double(DisclosureCheck, kind: "caution") }

  # NOTE: Working with doubles so it is a lot more easier to understand what is going on
  describe "#spent_date_for" do
    context "with relevant orders with 2 convictions" do
      before do
        allow(calculator).to receive(:proceedings).and_return([conviction_a, conviction_b])
      end

      # see graph in docs/results/08_relevant_order_3.png
      context "with conviction A with 2 sentences (non-relevant and relevant)", \
              "with conviction B with 1 sentence (non relevant)" do
        # conviction A with:
        # 1 non relevant order
        # 1 relevant order, the longest of both (spent in 2024, 12, 1)

        # conviction B with:
        # 1 non relevant order,
        #   overlaps with non relevant order of conviction A
        #   but is spent before relevant order of conviction A
        #
        # The outcome is:
        #  Conviction A is spent when relevant order sentence is spent
        #  Conviction B is spent when it's non relevant setence is spent

        let(:conviction_a) do
          instance_double(
            Calculators::Multiples::Proceedings,
            conviction?: true,
            conviction_date: Date.new(2010, 1, 1),
            spent_date: Date.new(2024, 12, 31),
            spent_date_without_relevant_orders: Date.new(2020, 12, 31),
          )
        end

        let(:conviction_b) do
          instance_double(
            Calculators::Multiples::Proceedings,
            conviction?: true,
            conviction_date: Date.new(2012, 1, 1),
            spent_date: Date.new(2022, 12, 31),
            spent_date_without_relevant_orders: Date.new(2022, 12, 31),
          )
        end

        it "returns the spent date for the matching check group" do
          expect(calculator.spent_date_for(conviction_a)).to eq(Date.new(2024, 12, 31))
          expect(calculator.spent_date_for(conviction_b)).to eq(Date.new(2022, 12, 31))
        end
      end
    end

    context "with relevant orders with 3 convictions" do
      before do
        allow(calculator).to receive(:proceedings).and_return([conviction_a, conviction_b, conviction_c])
      end

      # See graph in docs/results/06_relevant_order_1.png
      context "conviction A with 2 sentences (relevant and non relevant)," \
              "conviction B with 1 relevant order sentence, conviction C with 1 non relevant sentence" do
        # conviction with:
        # 1 relevant order, the longest of both, spent_date: 1 Jan 2005
        #  1 non relevant order, spent_date: 1 Jan 2003
        let(:conviction_a) do
          instance_double(
            Calculators::Multiples::Proceedings,
            conviction?: true,
            conviction_date: Date.new(2001, 1, 1),
            spent_date: Date.new(2005, 1, 1),
            spent_date_without_relevant_orders: Date.new(2003, 1, 1),
          )
        end

        # conviction with non relevant order
        # overlaps with conviction A
        let(:conviction_b) do
          instance_double(
            Calculators::Multiples::Proceedings,
            conviction?: true,
            conviction_date: Date.new(2000, 1, 1),
            spent_date: Date.new(2002, 1, 1),
            spent_date_without_relevant_orders: Date.new(2002, 1, 1),
          )
        end

        # conviction with non relevant order
        # overlaps with relevant sentence of conviction A
        let(:conviction_c) do
          instance_double(
            Calculators::Multiples::Proceedings,
            conviction?: true,
            conviction_date: Date.new(2004, 6, 1),
            spent_date: Date.new(2006, 6, 1),
            spent_date_without_relevant_orders: Date.new(2006, 6, 1),
          )
        end

        it "returns the spent date for the matching check group" do
          expect(calculator.spent_date_for(conviction_a)).to eq(Date.new(2005, 1, 1))
          expect(calculator.spent_date_for(conviction_b)).to eq(Date.new(2003, 1, 1))
          expect(calculator.spent_date_for(conviction_c)).to eq(Date.new(2006, 6, 1))
        end
      end

      # See graph in docs/results/07_relevant_order_2.png
      context "conviction A with 2 sentences (relevant & non-relevant) conviction B with 1 non-relevant sentence - overlaps A," \
              "conviction C with 1 non-relevant sentence - overlaps non-relevant sentence of conviction A" do
        # conviction with:
        # 1 relevant order, the longest of both, spent_date: 1 June 2008
        # 1 non relevant order, spent_date: 1 Jan 2006
        let(:conviction_a) do
          instance_double(
            Calculators::Multiples::Proceedings,
            conviction?: true,
            conviction_date: Date.new(2003, 1, 1),
            spent_date: Date.new(2008, 6, 1), # relevant order
            spent_date_without_relevant_orders: Date.new(2006, 1, 1), # non-relevant order
          )
        end

        # conviction with non relevant order
        # overlaps with conviction A
        let(:conviction_b) do
          instance_double(
            Calculators::Multiples::Proceedings,
            conviction?: true,
            conviction_date: Date.new(2000, 1, 1),
            spent_date: Date.new(2004, 1, 1),
            # same date, meaning there's no relevant order
            spent_date_without_relevant_orders: Date.new(2004, 1, 1),
          )
        end

        # conviction with non relevant order
        # overlaps with relevant sentence of conviction A
        let(:conviction_c) do
          instance_double(
            Calculators::Multiples::Proceedings,
            conviction?: true,
            conviction_date: Date.new(2005, 1, 1),
            spent_date: Date.new(2012, 6, 1),
            # same date, meaning there's no relevant order
            spent_date_without_relevant_orders: Date.new(2012, 6, 1),
          )
        end

        # Because there's an overlap between convictions A & C,
        # the spent date of Conviction B is extended to meet the
        # spent date of the non-relevant sentence found in Conviction C
        #
        it "returns the spent date of the convictions" do
          expect(calculator.spent_date_for(conviction_a)).to eq(Date.new(2012, 6, 1))
          expect(calculator.spent_date_for(conviction_b)).to eq(Date.new(2012, 6, 1))
          expect(calculator.spent_date_for(conviction_c)).to eq(Date.new(2012, 6, 1))
        end
      end
    end

    context "when conviction with 2 sentences, and one simple caution" do
      before do
        allow(calculator).to receive(:proceedings).and_return([conviction_1, conviction_2])
      end

      let(:conviction_1) do
        instance_double(
          Calculators::Multiples::Proceedings,
          conviction?: true,
          conviction_date: Date.new(2020, 1, 1),
          spent_date: Date.new(2022, 1, 1),
          spent_date_without_relevant_orders: Date.new(2022, 1, 1),
        )
      end

      let(:conviction_2) do
        instance_double(
          Calculators::Multiples::Proceedings,
          conviction?: false,
          conviction_date: nil,
          spent_date: ResultsVariant::SPENT_SIMPLE,
          spent_date_without_relevant_orders: ResultsVariant::SPENT_SIMPLE,
        )
      end

      it "returns the spent date for the matching check group" do
        expect(calculator.spent_date_for(conviction_1)).to eq(Date.new(2022, 1, 1))
        expect(calculator.spent_date_for(conviction_2)).to eq(ResultsVariant::SPENT_SIMPLE)
      end
    end

    context "with conviction with 2 sentences, and another, separate proceedings conviction" do
      before do
        allow(calculator).to receive(:proceedings).and_return([conviction_1, conviction_2])
      end

      context "when all sentences are dates" do
        context "and there is overlapping of rehabilitation periods" do
          let(:conviction_1) do
            instance_double(
              Calculators::Multiples::Proceedings,
              conviction?: true,
              conviction_date: Date.new(2020, 1, 1),
              spent_date: Date.new(2022, 1, 1),
              spent_date_without_relevant_orders: Date.new(2022, 1, 1),
            )
          end

          let(:conviction_2) do
            instance_double(
              Calculators::Multiples::Proceedings,
              conviction?: true,
              conviction_date: Date.new(2021, 1, 1),
              spent_date: Date.new(2025, 1, 1),
              spent_date_without_relevant_orders: Date.new(2025, 1, 1),
            )
          end

          it "returns the spent date for the matching check group" do
            expect(calculator.spent_date_for(conviction_1)).to eq(Date.new(2025, 1, 1))
            expect(calculator.spent_date_for(conviction_2)).to eq(Date.new(2025, 1, 1))
          end
        end

        context "when there is no overlapping of rehabilitation periods" do
          let(:conviction_1) do
            instance_double(
              Calculators::Multiples::Proceedings,
              conviction?: true,
              conviction_date: Date.new(2020, 1, 1),
              spent_date: Date.new(2022, 1, 1),
              spent_date_without_relevant_orders: Date.new(2022, 1, 1),
            )
          end

          let(:conviction_2) do
            instance_double(
              Calculators::Multiples::Proceedings,
              conviction?: true,
              conviction_date: Date.new(2023, 1, 1),
              spent_date: Date.new(2025, 1, 1),
              spent_date_without_relevant_orders: Date.new(2025, 1, 1),
            )
          end

          it "returns the spent date for the matching check group" do
            expect(calculator.spent_date_for(conviction_1)).to eq(Date.new(2022, 1, 1))
            expect(calculator.spent_date_for(conviction_2)).to eq(Date.new(2025, 1, 1))
          end
        end
      end

      # Rules (assuming there are overlaps):
      #
      #   - Everything (that has an end date) given before a "never spent"
      #     conviction becomes never spent.
      #
      #   - Everything afterwards is not affected by the never spent.
      #
      context "when one of the sentences has never spent length" do
        let(:conviction_1) do
          instance_double(
            Calculators::Multiples::Proceedings,
            conviction?: true,
            conviction_date: Date.new(2020, 1, 1),
            spent_date: spent_date_1,
            spent_date_without_relevant_orders: spent_date_1,
          )
        end

        let(:conviction_2) do
          instance_double(
            Calculators::Multiples::Proceedings,
            conviction?: true,
            conviction_date: Date.new(2021, 1, 1),
            spent_date: spent_date_2,
            spent_date_without_relevant_orders: spent_date_2,
          )
        end

        # See graph docs/results/03_never_spent_1.png
        context "when never spent sentence goes in the first conviction" do
          let(:spent_date_1) { ResultsVariant::NEVER_SPENT }
          let(:spent_date_2) { Date.new(2023, 1, 1) }

          it "returns the spent date for the matching check group" do
            expect(calculator.spent_date_for(conviction_1)).to eq(ResultsVariant::NEVER_SPENT)
            expect(calculator.spent_date_for(conviction_2)).to eq(Date.new(2023, 1, 1))
          end
        end

        # See graph docs/results/04_never_spent_2.png
        context "when never spent sentence goes in the second conviction" do
          let(:spent_date_1) { Date.new(2023, 1, 1) }
          let(:spent_date_2) { ResultsVariant::NEVER_SPENT }

          it "returns the spent date for the matching check group" do
            expect(calculator.spent_date_for(conviction_1)).to eq(ResultsVariant::NEVER_SPENT)
            expect(calculator.spent_date_for(conviction_2)).to eq(ResultsVariant::NEVER_SPENT)
          end
        end
      end

      context "when one of the sentences has indefinite length" do
        let(:conviction_1) do
          instance_double(
            Calculators::Multiples::Proceedings,
            conviction?: true,
            conviction_date: Date.new(2020, 1, 1),
            spent_date: spent_date_1,
            spent_date_without_relevant_orders: spent_date_1,
          )
        end

        let(:conviction_2) do
          instance_double(
            Calculators::Multiples::Proceedings,
            conviction?: true,
            conviction_date: Date.new(2021, 1, 1),
            spent_date: spent_date_2,
            spent_date_without_relevant_orders: spent_date_2,
          )
        end

        context "when indefinite sentence goes in the first conviction" do
          let(:spent_date_1) { ResultsVariant::INDEFINITE }
          let(:spent_date_2) { Date.new(2023, 1, 1) }

          it "returns the spent date for the matching check group" do
            expect(calculator.spent_date_for(conviction_1)).to eq(ResultsVariant::INDEFINITE)
            expect(calculator.spent_date_for(conviction_2)).to eq(Date.new(2023, 1, 1))
          end
        end

        context "when indefinite sentence goes in the second conviction" do
          let(:spent_date_1) { Date.new(2023, 1, 1) }
          let(:spent_date_2) { ResultsVariant::INDEFINITE }

          it "returns the spent date for the matching check group" do
            expect(calculator.spent_date_for(conviction_1)).to eq(ResultsVariant::INDEFINITE)
            expect(calculator.spent_date_for(conviction_2)).to eq(ResultsVariant::INDEFINITE)
          end
        end
      end

      context "when one of the sentences is never spent and the other is indefinite" do
        let(:conviction_1) do
          instance_double(
            Calculators::Multiples::Proceedings,
            conviction?: true,
            conviction_date: Date.new(2020, 1, 1),
            spent_date: spent_date_1,
            spent_date_without_relevant_orders: spent_date_1,
          )
        end

        let(:conviction_2) do
          instance_double(
            Calculators::Multiples::Proceedings,
            conviction?: true,
            conviction_date: Date.new(2021, 1, 1),
            spent_date: spent_date_2,
            spent_date_without_relevant_orders: spent_date_2,
          )
        end

        context "when never spent sentence goes in the first conviction and indefinite in the second conviction" do
          let(:spent_date_1) { ResultsVariant::NEVER_SPENT }
          let(:spent_date_2) { ResultsVariant::INDEFINITE }

          it "returns the spent date for the matching check group" do
            expect(calculator.spent_date_for(conviction_1)).to eq(ResultsVariant::NEVER_SPENT)
            expect(calculator.spent_date_for(conviction_2)).to eq(ResultsVariant::INDEFINITE)
          end
        end

        context "when indefinite sentence goes in the first conviction and never spent in the second conviction" do
          let(:spent_date_1) { ResultsVariant::INDEFINITE }
          let(:spent_date_2) { ResultsVariant::NEVER_SPENT }

          it "returns the spent date for the matching check group" do
            expect(calculator.spent_date_for(conviction_1)).to eq(ResultsVariant::NEVER_SPENT)
            expect(calculator.spent_date_for(conviction_2)).to eq(ResultsVariant::NEVER_SPENT)
          end
        end
      end
    end

    context "with 3 separate proceedings convictions" do
      before do
        allow(calculator).to receive(:proceedings).and_return([conviction_1, conviction_2, conviction_3])
      end

      let(:conviction_1) do
        instance_double(
          Calculators::Multiples::Proceedings,
          conviction?: true,
          conviction_date: Date.new(2020, 1, 1),
          spent_date: Date.new(2021, 1, 1),
          spent_date_without_relevant_orders: Date.new(2021, 1, 1),
        )
      end

      let(:conviction_2) do
        instance_double(
          Calculators::Multiples::Proceedings,
          conviction?: true,
          conviction_date: Date.new(2020, 10, 25),
          spent_date: ResultsVariant::NEVER_SPENT,
          spent_date_without_relevant_orders: ResultsVariant::NEVER_SPENT,
        )
      end

      let(:conviction_3) do
        instance_double(
          Calculators::Multiples::Proceedings,
          conviction?: true,
          conviction_date: Date.new(2023, 1, 1),
          spent_date: Date.new(2025, 1, 1),
          spent_date_without_relevant_orders: Date.new(2025, 1, 1),
        )
      end

      it "returns the spent date for the matching check group" do
        expect(calculator.spent_date_for(conviction_1)).to eq(ResultsVariant::NEVER_SPENT)
        expect(calculator.spent_date_for(conviction_2)).to eq(ResultsVariant::NEVER_SPENT)
        expect(calculator.spent_date_for(conviction_3)).to eq(Date.new(2025, 1, 1))
      end
    end

    context "with 4 separate proceedings convictions" do
      before do
        allow(calculator).to receive(:proceedings).and_return([conviction_1, conviction_2, conviction_3, conviction_4])
      end

      let(:conviction_1) do
        instance_double(
          Calculators::Multiples::Proceedings,
          conviction?: true,
          conviction_date: Date.new(2020, 1, 1),
          spent_date: Date.new(2021, 1, 1),
          spent_date_without_relevant_orders: Date.new(2021, 1, 1),
        )
      end

      let(:conviction_2) do
        instance_double(
          Calculators::Multiples::Proceedings,
          conviction?: true,
          conviction_date: Date.new(2020, 6, 1),
          spent_date: Date.new(2021, 1, 1),
          spent_date_without_relevant_orders: Date.new(2021, 1, 1),
        )
      end

      let(:conviction_3) do
        instance_double(
          Calculators::Multiples::Proceedings,
          conviction?: true,
          conviction_date: Date.new(2023, 1, 1),
          spent_date: ResultsVariant::NEVER_SPENT,
          spent_date_without_relevant_orders: ResultsVariant::NEVER_SPENT,
        )
      end

      let(:conviction_4) do
        instance_double(
          Calculators::Multiples::Proceedings,
          conviction?: true,
          conviction_date: Date.new(2025, 1, 1),
          spent_date: Date.new(2025, 12, 31),
          spent_date_without_relevant_orders: Date.new(2025, 12, 31),
        )
      end

      it "returns the spent date for the matching check group" do
        expect(calculator.spent_date_for(conviction_1)).to eq(Date.new(2021, 1, 1))
        expect(calculator.spent_date_for(conviction_2)).to eq(Date.new(2021, 1, 1))
        expect(calculator.spent_date_for(conviction_3)).to eq(ResultsVariant::NEVER_SPENT)
        expect(calculator.spent_date_for(conviction_4)).to eq(Date.new(2025, 12, 31))
      end
    end

    context "with 4 separate proceedings convictions (3 has a spent date and 4 has never spent)" do
      before do
        allow(calculator).to receive(:proceedings).and_return([conviction_1, conviction_2, conviction_3, conviction_4])
      end

      let(:conviction_1) do
        instance_double(
          Calculators::Multiples::Proceedings,
          conviction?: true,
          conviction_date: Date.new(2020, 1, 1),
          spent_date: Date.new(2021, 1, 1),
          spent_date_without_relevant_orders: Date.new(2021, 1, 1),
        )
      end

      let(:conviction_2) do
        instance_double(
          Calculators::Multiples::Proceedings,
          conviction?: true,
          conviction_date: Date.new(2020, 6, 1),
          spent_date: Date.new(2021, 1, 1),
          spent_date_without_relevant_orders: Date.new(2021, 1, 1),
        )
      end

      let(:conviction_3) do
        instance_double(
          Calculators::Multiples::Proceedings,
          conviction?: true,
          conviction_date: Date.new(2023, 1, 1),
          spent_date: Date.new(2026, 1, 1),
          spent_date_without_relevant_orders: Date.new(2026, 1, 1),
        )
      end

      let(:conviction_4) do
        instance_double(
          Calculators::Multiples::Proceedings,
          conviction?: true,
          conviction_date: Date.new(2025, 1, 1),
          spent_date: ResultsVariant::NEVER_SPENT,
          spent_date_without_relevant_orders: ResultsVariant::NEVER_SPENT,
        )
      end

      it "returns the spent date for the matching check group" do
        expect(calculator.spent_date_for(conviction_1)).to eq(Date.new(2021, 1, 1))
        expect(calculator.spent_date_for(conviction_2)).to eq(Date.new(2021, 1, 1))
        expect(calculator.spent_date_for(conviction_3)).to eq(ResultsVariant::NEVER_SPENT)
        expect(calculator.spent_date_for(conviction_4)).to eq(ResultsVariant::NEVER_SPENT)
      end
    end
  end

  describe "#all_spent?" do
    let(:conviction_1) { Calculators::Multiples::Proceedings.new(check_group1) }
    let(:conviction_2) { Calculators::Multiples::Proceedings.new(check_group2) }

    before do
      calculator_spy = verifying_spy(calculator)
      allow(calculator_spy).to receive(:proceedings).and_return([conviction_1, conviction_2])

      allow(calculator_spy).to receive(:spent_date).and_return(spent_dates[0])
      allow(calculator_spy).to receive(:spent_date).and_return(spent_dates[1])
    end

    context "when there is an offence that will never be spent" do
      let(:spent_dates) { [ResultsVariant::NEVER_SPENT, Date.yesterday] }

      it "returns false" do
        expect(calculator.all_spent?).to eq(false)
      end
    end

    context "when there is an offence with `spent_simple`" do
      let(:spent_dates) { [Date.yesterday, ResultsVariant::SPENT_SIMPLE] }

      it "considers the spent_simple as spent" do
        expect(calculator.all_spent?).to eq(true)
      end
    end

    context "when there is an offence with `indefinite`" do
      let(:spent_dates) { [ResultsVariant::INDEFINITE, Date.tomorrow] }

      it "excludes the `indefinite` offence, and check the other dates" do
        expect(calculator.all_spent?).to eq(false)
      end
    end

    context "when there are future dates" do
      let(:spent_dates) { [Date.yesterday, Date.tomorrow] }

      it "checks if all the dates are in the past" do
        expect(calculator.all_spent?).to eq(false)
      end
    end

    context "when there are past dates" do
      let(:spent_dates) { [Date.yesterday, Date.yesterday - 3.days] }

      it "checks if all the dates are in the past" do
        expect(calculator.all_spent?).to eq(true)
      end
    end
  end
end
# rubocop:enable RSpec/SubjectStub
