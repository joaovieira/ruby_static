module RubyStatic
  # This require basically states that we're going to require the engine
  # if you are using rails and your rails version is 3.x..
  require 'ruby_static/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
  
  # Adding a couple of extra files here and you can view all of the source
  # to see what they have in them.
  require 'templates/rstatic/rstatic_template'
  require 'ruby_static/analyser'
  require 'extensions/metric_fu/reek_bluff_grapher'
  
  NAME = 'Static'
  PROGRAMMING_LANGUAGE = "Ruby"
  ANALYSER = self.name.split('::').first
  OUTPUT_NAME = 'reek'
end
