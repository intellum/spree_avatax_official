module SpreeAvataxOfficial
  module Settings
    class UpdateService < SpreeAvataxOfficial::Base
      def call(params:)
        update_settings(params)
      end

      private

      def update_settings(params)
        update_address_settings(params[:ship_from])
        SpreeAvataxOfficial::Config.enabled                    = params[:enabled] if params.key?(:enabled)
        SpreeAvataxOfficial::Config.endpoint                   = params[:endpoint] if params.key?(:endpoint)
        SpreeAvataxOfficial::Config.address_validation_enabled = params[:address_validation_enabled] if params.key?(:address_validation_enabled)
        SpreeAvataxOfficial::Config.commit_transaction_enabled = params[:commit_transaction_enabled] if params.key?(:commit_transaction_enabled)
        SpreeAvataxOfficial::Config.enabled                    = params[:enabled] if params.key?(:enabled)
      end

      def update_address_settings(ship_from_params)
        return unless ship_from_params

        SpreeAvataxOfficial::Config.ship_from_address = {
            line1:      ship_from_params[:line1],
            line2:      ship_from_params[:line2],
            city:       ship_from_params[:city],
            region:     ship_from_params[:region],
            country:    ship_from_params[:country],
            postalCode: ship_from_params[:postal_code]
        }
      end
    end
  end
end
