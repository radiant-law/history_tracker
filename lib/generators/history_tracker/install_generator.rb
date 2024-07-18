require 'rails/generators'
require 'rails/generators/migration'

module HistoryTracker
  class Install < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)

    def self.next_migration_number(path)
      (Time.now.utc.strftime("%Y%m%d%H%M%S").to_i + 1).to_s
    end

    def generate_migration
      migration_template "create_audit_histories.rb", "db/migrate/create_audit_histories.rb"
    end
  end
end