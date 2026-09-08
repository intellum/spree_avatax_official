source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails-controller-testing'
# Pin to match the consuming app (intellum-ecommerce: Spree 5.3.x on Rails 7.2)
# so the suite tests the real target, not a newer Spree/Rails line.
# spree_backend has no Spree 5 line (dropped with CORE-3579); the admin surface
# moved to the app's custom admin, so the suite only needs core.
gem 'rails', '~> 7.2.0'
gem 'spree', '~> 5.3.0'
gem 'sqlite3'
# Rails 7.2's ActiveRecord::Type::Json calls JSON.generate(quirks_mode:), which
# json 3.0 removed. Pin to the 2.x line the app uses.
gem 'json', '~> 2.19'

gemspec
