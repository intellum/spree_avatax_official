require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::CreateService do
  describe '#call' do
    context 'with correct parameters' do
      let(:order) { create(:order_with_line_items, ship_address: create(:usa_address)) }
      let(:ship_from_address) { create(:usa_address) }

      context 'for SalesOrder and Avalara API successfull response' do
        subject { described_class.call(order: order, ship_from_address: ship_from_address, transaction_type: 'SalesOrder') }

        it 'returns positive result' do
          VCR.use_cassette('spree_avatax_official/transactions/create/sales_order_success') do
            result = subject
            response = result.value

            expect(result.success?).to eq true
            expect(response['type']).to eq 'SalesOrder'
            expect(response['status']).to eq 'Temporary'
            expect(response['lines'].size).to eq 1
            expect(SpreeAvataxOfficial::Transaction.count).to eq 0
          end
        end
      end

      context 'for SalesInvoice and Avalara API successfull response' do
        subject { described_class.call(order: order, ship_from_address: ship_from_address, transaction_type: 'SalesInvoice') }

        it 'returns positive result' do
          VCR.use_cassette('spree_avatax_official/transactions/create/invoice_order_success') do
            result = subject
            response = result.value

            expect(result.success?).to eq true
            expect(response['type']).to eq 'SalesInvoice'
            expect(response['status']).to eq 'Saved'
            expect(response['lines'].size).to eq 1
            expect(SpreeAvataxOfficial::Transaction.count).to eq 1
          end
        end
      end

      # Unfortunetly path method in https://github.com/avadev/AvaTax-REST-V2-Ruby-SDK/blob/master/lib/avatax/request.rb#L29
      # removes all query params, what makes us unable to test timeout with '$include' => 'ForceTimeout' query param.
      xcontext 'and Avalara API timeout' do
        subject { described_class.new(order: order, ship_from_address: ship_from_address, transaction_type: 'SalesOrder', options: { '$include' => 'ForceTimeout' }) }

        it 'returns negative result' do
          VCR.use_cassette('spree_avatax_official/transactions/create/timeout') do
            result = subject
            response = result.value

            expect(result.success?).to eq false
            expect(response['error']).to be_present
            expect(response['error']['code']).to eq 'TimeoutRequested'
          end
        end
      end
    end

    context 'with incorrect parameters' do
      let(:order_without_line_items) { create(:order, ship_address: create(:usa_address)) }
      let(:ship_from_address) { create(:usa_address) }

      subject { described_class.call(order: order_without_line_items, ship_from_address: ship_from_address, transaction_type: 'SalesOrder') }

      it 'returns negative result' do
        VCR.use_cassette('spree_avatax_official/transactions/create/failure') do
          result = subject
          response = result.value

          expect(result.success?).to eq false
          expect(response['error']).to be_present
          expect(response['error']['code']).to eq 'MissingLine'
        end
      end
    end
  end
end