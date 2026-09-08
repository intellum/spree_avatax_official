module SpreeAvataxOfficial
  class Engine < Rails::Engine
    require 'spree/core'
    require 'avatax'

    isolate_namespace SpreeAvataxOfficial
    engine_name 'spree_avatax_official'

    config.autoload_paths += %W[#{config.root}/lib]

    # SpreeAvataxOfficial::Config backs the settings the host app assigns in its
    # config/initializers, which run before Zeitwerk would autoload app/models
    # under Rails 7.2. So: tell the autoloader to ignore configuration.rb (we load
    # it ourselves, avoiding a double-load conflict on eager_load), require it
    # before load_config_initializers, and build Config there. to_prepare keeps it
    # rebuilt across code reloads in development.
    # Config lives in app/models, which Zeitwerk doesn't autoload yet while the
    # host app's config/initializers run (they assign SpreeAvataxOfficial::Config.*)
    # under Rails 7.2. Ignore it in the autoloader (we require it ourselves, so no
    # double-load conflict on eager_load) and build Config before those run.
    config_path = "#{config.root}/app/models/spree_avatax_official/configuration.rb"

    initializer 'spree_avatax_official.ignore_config', before: :set_autoload_paths do
      Rails.autoloaders.main.ignore(config_path)
    end

    initializer 'spree_avatax_official.config', before: :load_config_initializers do
      require config_path
      SpreeAvataxOfficial::Config ||= SpreeAvataxOfficial::Configuration.new
    end

    config.to_prepare do
      SpreeAvataxOfficial::Config ||= SpreeAvataxOfficial::Configuration.new
    end

    # Register the tax calculator after boot: config.after_initialize runs once
    # autoloading is active (so the calculator + its Spree::Calculator superclass
    # resolve) and after Spree has populated the tax_rates calculators collection.
    config.after_initialize do |app|
      calculators = app.config.spree.calculators.tax_rates
      klass = SpreeAvataxOfficial::Calculator::AvataxTransactionCalculator
      calculators << klass unless calculators.include?(klass)
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.application.config.enable_reloading ? load(c) : require(c)
      end
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
