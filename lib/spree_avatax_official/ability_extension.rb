module SpreeAvataxOfficial::AbilityExtension
  def apply_admin_permissions(user, current_store)
    super
    can :manage, :avatax_accounts
    can :manage, :avatax_settings
    can :manage, :avalara_entity_use_codes
  end

end
