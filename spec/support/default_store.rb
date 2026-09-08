# The gem dropped spree_auth_devise/backend, so nothing seeds a Spree::Store in
# the dummy. Spree's order factory attaches orders to Spree::Store.default, which
# supplies their currency — without a persisted default store, orders fail
# "Currency can't be blank". Seed one per example.
RSpec.configure do |config|
  config.before(:each) do
    next if Spree::Store.where(default: true).exists?

    # A generic (sequenced-ISO) country avoids colliding with the US country the
    # address/order specs create themselves; the store only needs *a* default.
    FactoryBot.create(:store, default: true, default_currency: 'USD',
                              default_country: FactoryBot.create(:country))
  end
end
