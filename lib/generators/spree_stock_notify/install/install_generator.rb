module SpreeStockNotify
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root(File.expand_path(File.dirname(__FILE__)))
      class_option :migrate, type: :boolean, default: true

      def copy_sidekiq_rb_file
        copy_file 'templates/sidekiq.rb', 'config/initializers/sidekiq.rb'
      end

      def copy_schedule_yml_file
        copy_file 'templates/schedule.yml', 'config/schedule.yml'
      end

      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/spree_stock_notify\n"
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_stock_notify'
      end

      def run_migrations
        run_migrations = options[:migrate] || ['', 'y', 'Y'].include?(ask('Would you like to run the migrations now? [Y/n]'))
        if run_migrations
          run 'bundle exec rails db:migrate'
        else
          puts 'Skipping rails db:migrate, don\'t forget to run it!'
        end
      end
    end
  end
end
