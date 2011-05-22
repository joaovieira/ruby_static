require 'rails/generators'

module RubyStatic
  module Generators
	class InstallGenerator < Rails::Generators::Base
	  
	  #Add programming language to application's database
	  def add_programming_language
		ProgrammingLanguage.table_exists?
		p_language = RubyStatic::PROGRAMMING_LANGUAGE
		if ProgrammingLanguage.find_by_name(p_language).nil?
		  ProgrammingLanguage.create!(:name => p_language)
		end
	  rescue
		raise "ActiveRecord::ProgrammingLanguage does not exist."
	  end
	  
	  #Add metric to application's database
	  def add_metric
		p_language = ProgrammingLanguage.find_by_name(RubyStatic::PROGRAMMING_LANGUAGE)
		  
		begin
		  Metric.table_exists?
		  metric_analyser = RubyStatic::ANALYSER
		  metric_name = RubyStatic::NAME
		  if Metric.find_by_name(metric_name).nil?
			metric = Metric.new(:name => metric_name, :analyser => metric_analyser)
			metric.programming_language = p_language
			metric.save!
		  end  
		rescue
		  raise "ActiveRecord::Metric does not exist."
		end
	  end
	  
	  def end_install
		puts "#{RubyStatic::ANALYSER}: #{RubyStatic::PROGRAMMING_LANGUAGE} #{RubyStatic::NAME} sucessfully installed!"
	  end
	end
  end
end
