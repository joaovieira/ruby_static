require 'metric_fu'

module RubyStatic
  class Analyser

    def self.run(results_dir, date)	
      # MetricFu local configurations
      MetricFu::Configuration.run do |config|
	    config.base_directory = File.join(results_dir, 'metrics')
	    config.data_directory = File.join(config.base_directory, '_data')
	    config.output_directory = File.join(config.base_directory, 'output', "#{date.strftime("%Y%m%d%H%M")}", RubyStatic::ANALYSER.underscore)	
  	    config.template_class = RstaticTemplate	
	    config.metrics = [:reek]
  	    config.graphs = [:reek]
	    config.code_dirs = [File.join(results_dir,'app'), File.join(results_dir,'lib')]
	    config.reek[:dirs_to_reek] = config.code_dirs
      end

      # Run metric fu!
      MetricFu.metrics.each {|metric| MetricFu.report.add(metric) }
      MetricFu.report.save_output(MetricFu.report.to_yaml, MetricFu.base_directory, "report.yml")
      MetricFu.report.save_output(MetricFu.report.to_yaml, MetricFu.data_directory, "#{date.strftime("%Y%m%d%H%M")}.yml")

      MetricFu.graphs.each {|graph| MetricFu.graph.add(graph, MetricFu.graph_engine) }
      MetricFu.graph.generate

      MetricFu.report.save_templatized_report
    end

  end
end
