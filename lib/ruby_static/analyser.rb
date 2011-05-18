require 'metric_fu'

module RubyStatic
  class Analyser

    def self.run(results_dir, date)
      # Configure metric fu paths
      MetricFu::Configuration.run do |config|
        config.metrics = [:reek]
        config.graphs = [:reek]
        config.template_class = RstaticTemplate
        config.base_directory = results_dir
	config.data_directory = File.join(results_dir, '_data')
	config.output_directory = File.join(results_dir, 'output', "#{date.strftime("%Y%m%d%H%M")}", 'ruby_static')	
        config.code_dirs = [File.join(results_dir, 'app'), File.join(results_dir, 'lib')]
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
