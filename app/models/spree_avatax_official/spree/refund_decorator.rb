module SpreeAvataxOfficial
  module Spree
    module RefundDecorator
      def self.prepended(base)
        base.after_create :refund_in_avatax

        base.delegate :order,                    to: :payment
        base.delegate :inventory_units, :number, to: :order, prefix: true
      end

      private

      def refund_in_avatax
        enabled = SpreeAvataxOfficial::Config.enabled && SpreeAvataxOfficial::AvataxAccount.find_by(spree_store: order.store)&.enabled?
        return unless enabled && SpreeAvataxOfficial::Config.commit_transaction_enabled

        SpreeAvataxOfficial::Transactions::RefundService.call(refundable: self)
      end
    end
  end
end

::Spree::Refund.prepend ::SpreeAvataxOfficial::Spree::RefundDecorator
