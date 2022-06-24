module SpreeAvataxOfficial
  module Address
    class Validate < SpreeAvataxOfficial::Base
      def call(address:)
        response = send_request(address)

        return failure(response) if errors?(response)

        success(response)
      end

      private

      def errors?(response)
        response.body['messages'] || response.body['error']
      end

      def send_request(address)
        ship_to_address_model = SpreeAvataxOfficial::ShipToAddressPresenter.new(
          address: address
        ).to_json

        store_client(address).resolve_address(ship_to_address_model)
      end

      def store_client(address)
        address_sym = ::Spree::Config.tax_using_ship_address ? :ship_address : :bill_address
        order       = ::Spree::Order.incomplete.find_by(address_sym => self)
        client(order.store)
      end
    end
  end
end
