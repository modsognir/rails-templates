

# cleanup Gemfile
  gsub_file 'Gemfile', /#.*\n/, "\n"
  gsub_file 'Gemfile', /\n^\s*\n/, "\n"

# cleanup Routes
  gsub_file 'config/routes.rb', /  #.*\n/, "\n"
  gsub_file 'config/routes.rb', /\n^\s*\n/, "\n"

# set up examples
  run "cp config/database.yml config/database.yml.example"

# remove excess files
  run "rm public/index.html"

# add gems
  gem 'rspec-rails'
  gem 'email_spec'
  gem 'haml', '>= 3.1.6'
  gem 'haml-rails', '>= 0.3.4', :group => :development
  gem 'devise'

  run 'bundle install'

  generate 'devise:install'
  generate 'rspec:install'
  generate 'email_spec:steps'

  inject_into_file 'config/application.rb', :after => "Rails::Application\n" do <<-RUBY

    config.generators do |g|
      g.test_framework :rspec, :views => false, :fixture => true
      g.template_engine :haml
    end

RUBY
    end

# set up git repo
  git :init
  initializer '.gitignore', <<-CODE
log/\\*.log
log/\\*.pid
db/\\*.db
db/\\*.sqlite3
db/schema.rb
tmp/\\*\\*/\\*
.DS_Store
doc/api
doc/app
config/database.yml
CODE
  git :add => "."
  git :commit => "-m 'Initial Commit: Template'"