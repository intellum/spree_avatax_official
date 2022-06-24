module SpreeAvataxOfficial
  class AvataxAccount < ::Spree::Base
    belongs_to :spree_store, class_name: "Spree::Store"
  end
end
