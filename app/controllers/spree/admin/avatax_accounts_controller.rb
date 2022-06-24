module Spree
  module Admin
    class AvataxAccountsController < Spree::Admin::BaseController
      def edit
        @avatax_account = SpreeAvataxOfficial::AvataxAccount.find_or_initialize_by(spree_store: current_store)
      end

      def update
        @avatax_account = SpreeAvataxOfficial::AvataxAccount.find_or_initialize_by(spree_store: current_store)

        if @avatax_account.update(avatax_account_params)
          flash[:success] = Spree.t('spree_avatax_official.avatax_account_updated')
          redirect_to edit_admin_avatax_accounts_path
        else
          flash[:error] = Spree.t('spree_avatax_official.wrong_endpoint_url')
          render :edit
        end
      end

      private

      def avatax_account_params
        params.require(:avatax_account).permit(:enabled, :company_code, :account_number, :license_key)
          .merge(account_id: current_account.id)
      end
    end
  end
end
