$:.push File.expand_path("../../templates", __FILE__)
require 'metadata'

require 'rails/generators'
#require 'rails/generators/migration'


module RubyStatic
  module Generators
	class InstallGenerator < Rails::Generators::Base
	  #include Rails::Generators::Migration
	  
	  source_root File.expand_path("../../templates", __FILE__)

	  #def self.next_migration_number(dirname) #:nodoc:
	  #  if ActiveRecord::Base.timestamped_migrations
	  #	   Time.now.utc.strftime("%Y%m%d%H%M%S")
	  #  else
	  #	   "%.3d" % (current_migration_number(dirname) + 1)
	  #  end
	  #end

	  # This method is pulling all of the migration data from the migration.rb template.
	  # After it pulls the migration date, it generates a migration in the main application
	  # called create_ruby_static_model_data...
	  # You can change the name of this if and when you make your own engine.
	  #def create_migration_file
	  #  migration_template 'migration.rb', 'db/migrate/create_ruby_static_model_data.rb'
	  #end
	  
	  #Add programming language to application's database
	  def add_programming_language
		ProgrammingLanguage.table_exists?
		p_language = RubyStatic::Metadata::PROGRAMMING_LANGUAGE
		if ProgrammingLanguage.find_by_name(p_language).nil?
		  ProgrammingLanguage.create!(:name => p_language)
		end
	  rescue
		raise "ActiveRecord::ProgrammingLanguage does not exist."
	  end
	  
	  #Add metric to application's database
	  def add_metric
		p_language = ProgrammingLanguage.find_by_name(RubyStatic::Metadata::PROGRAMMING_LANGUAGE)
		  
		begin
		  Metric.table_exists?
		  metric_analyser = RubyStatic::Metadata::ANALYSER
		  metric_name = RubyStatic::Metadata::NAME
		  if Metric.find_by_name(metric_name).nil?
			metric = Metric.new(:name => metric_name, :analyser => metric_analyser)
			metric.programming_language = p_language
			metric.save!
		  end  
		rescue
		  raise "ActiveRecord::Metric does not exist."
		end
	  end

          def copy_javascripts
            copy_file "bluff/bluff-min.js", "public/javascripts/bbluff-min.js"
	    copy_file "bluff/excanvas.js", "public/javascripts/cexcanvas.js" 
            copy_file "bluff/js-class.js", "public/javascripts/ajs-class.js" 
          end

	  def copy_stylesheets
	    copy_file "css/default.css", "public/stylesheets/default.css" 
	    copy_file "css/syntax.css", "public/stylesheets/syntax.css" 
	  end 
	  
	  def end_install
		puts "#{RubyStatic::Metadata::ANALYSER}: #{RubyStatic::Metadata::PROGRAMMING_LANGUAGE} #{RubyStatic::Metadata::NAME} sucessfully installed!"
	  end
	end
  end
end
