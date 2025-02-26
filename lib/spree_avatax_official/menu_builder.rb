module SpreeAvataxOfficial
  module MenuBuilder
    def self.add_menus(root)
      items = []
      items << ::Spree::Admin::MainMenu::ItemBuilder.new('avatax_tax_edit', '/primary/admin/avatax_accounts/edit').
        with_admin_ability_check(::Spree::Menu).
        with_match_path('/avatax_accounts/edit').
        with_label_translation_key('spree_avatax_official.avatax_account').
        build
      items << ::Spree::Admin::MainMenu::ItemBuilder.new('avatax_tax_settings_edit', '/primary/admin/avatax_settings/edit').
        with_admin_ability_check(::Spree::Menu).
        with_match_path('/avatax_settings/edit').
        with_label_translation_key('spree_avatax_official.settings').
        build
      items << ::Spree::Admin::MainMenu::ItemBuilder.new('avatax_tax_use_codes_edit', '/primary/admin/avalara_entity_use_codes').
        with_admin_ability_check(::Spree::Menu).
        with_match_path('/avalara_entity_use_codes').
        with_label_translation_key('spree_avatax_official.avalara_entity_use_code').
        build
      items.each do |item|
        root.add_to_section('integrations', item)
      end
    end
  end
end
