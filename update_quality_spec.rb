require 'rspec'
require 'update_quality'

describe '#update_quality' do

  context 'Given a single award' do
    let(:initial_expires_in) { 5 }
    let(:initial_quality) { 10 }
    let(:award) { Award.new(name, initial_expires_in, initial_quality) }

    context 'when quality is updated' do
      before do
        update_quality([award])
      end

      context 'given a normal award' do
        let(:name) { 'NORMAL ITEM' }

        before do
          # Verify that this is always true in the current context
          expect(award.expires_in).to eq(initial_expires_in-1)
        end

        context 'before expiration date' do
          specify { expect(award.quality).to eq(initial_quality-1) }
        end

        context 'on expiration date' do
          let(:initial_expires_in) { 0 }
          specify { expect(award.quality).to eq(initial_quality-2) }
        end

        context 'after expiration date' do
          let(:initial_expires_in) { -10 }
          specify { expect(award.quality).to eq(initial_quality-2) }
        end

        context 'of zero quality' do
          let(:initial_quality) { 0 }
          specify { expect(award.quality).to eq(0) }
        end
      end

      context 'given Blue First' do
        let(:name) { 'Blue First' }

        before do
          # Verify that this is always true in the current context
          award.expires_in.should == initial_expires_in-1
        end

        context 'before expiration date' do
          specify { expect(award.quality).to eq(initial_quality+1) }

          context 'with max quality' do
            let(:initial_quality) { 50 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end

        context 'at expiration date' do
          let(:initial_expires_in) { 0 }
          specify { expect(award.quality).to eq(initial_quality+2) }

          context 'near maxqual' do
            let(:initial_quality) { 49 }
            specify { expect(award.quality).to eq(50) }
          end

          context 'with maxquyal' do
            let(:initial_quality) { 50 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end

        context 'after expiration_date' do
          let(:initial_expires_in) { -10 }
          specify { expect(award.quality).to eq(initial_quality+2) }

          context 'with maxqual' do
            let(:initial_quality) { 50 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end
      end

      context 'recieve bluedistinctionplus' do
        let(:initial_quality) { 80 }
        let(:name) { 'Blue Distinction Plus' }

        before do
          # Verify that this is always true in the current context
          award.expires_in.should == initial_expires_in
        end

        context 'b4 expiration-date' do
          specify { expect(award.quality).to eq(initial_quality) }
        end

        context 'day of expiration_date' do
          let(:initial_expires_in) { 0 }
          specify { expect(award.quality).to eq(initial_quality) }
        end

        context 'past expirationdate' do
          let(:initial_expires_in) { -10 }
          specify { expect(award.quality).to eq(initial_quality) }
        end
      end

      context 'recieve bluecompare' do
        let(:name) { 'Blue Compare' }

        before do
          # Verify that this is always true in the current context
          award.expires_in.should == initial_expires_in-1
        end

        context 'long before expiration date' do
          let(:initial_expires_in) { 11 }
          specify { expect(award.quality).to eq(initial_quality+1) }

          context 'at maxqual' do
            let(:initial_quality) { 50 }
          end
        end

        context 'somewhat close to expiration date (upper bound)' do
          let(:initial_expires_in) { 10 }
          specify { expect(award.quality).to eq(initial_quality+2) }

          context 'at maxqual' do
            let(:initial_quality) { 50 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end

        context 'somewhat close to expiration date (lower bound)' do
          let(:initial_expires_in) { 6 }
          specify { expect(award.quality).to eq(initial_quality+2) }

          context 'at maxqual' do
            let(:initial_quality) { 50 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end

        context 'extremely close to expiration date (upper bound)' do
          let(:initial_expires_in) { 5 }
          specify { expect(award.quality).to eq(initial_quality+3) }

          context 'at maxqual' do
            let(:initial_quality) { 50 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end

        context 'extremely close to expiration date (lower bound)' do
          let(:initial_expires_in) { 1 }
          specify { expect(award.quality).to eq(initial_quality+3) }

          context 'at maxqual' do
            let(:initial_quality) { 50 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end

        context 'AT expirationdate' do
          let(:initial_expires_in) { 0 }
          specify { expect(award.quality).to eq(0) }
        end

        context 'after expirationdate' do
          let(:initial_expires_in) { -10 }
          specify { expect(award.quality).to eq(0) }
        end
      end

      context 'recieve bluestar award' do
        # before { pending }
        let(:name) { 'Blue Star' }
        before { award.expires_in.should == initial_expires_in-1 }

        context 'before the expirationdate' do
          let(:initial_expires_in) { 5 }
          specify { expect(award.quality).to eq(initial_quality-2) }

          context 'at zero qual' do
            let(:initial_quality) { 0 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end

        context 'on expirationdate' do
          let(:initial_expires_in) { 0 }
          specify { expect(award.quality).to eq(initial_quality-4) }

          context 'at zero qual' do
            let(:initial_quality) { 0 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end

        context 'after expirationdate' do
          let(:initial_expires_in) { -10 }
          specify { expect(award.quality).to eq(initial_quality-4) }

          context 'at zero qual' do
            let(:initial_quality) { 0 }
            specify { expect(award.quality).to eq(initial_quality) }
          end
        end
      end
    end
  end

  context 'recieve more than several award' do
    let(:awards) {
      [
        Award.new('NORMAL ITEM', 5, 10),
        Award.new('Blue First', 3, 10),
      ]
    }

    context 'when quality updated' do
      before do
        update_quality(awards)
      end

      specify { expect(awards[0].quality).to eq(9) }
      specify { expect(awards[0].expires_in).to eq(4) }

      specify { expect(awards[1].quality).to eq(11) }
      specify { expect(awards[1].expires_in).to eq(2) }
    end
  end
end
