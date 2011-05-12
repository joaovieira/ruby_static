require 'ruby_static/config'
require 'metric_fu'

module RubyStatic
  class Analyser

    def self.run dir
      project_metrics_dir = File.join(dir, 'tmp', 'ruby_static')

      # Configure metric fu paths
      MetricFu::Configuration.run do |config|    
        config.base_directory = project_metrics_dir
	config.data_directory = File.join(project_metrics_dir, '_data')
	config.output_directory = File.join(project_metrics_dir, 'output')
        config.code_dirs = [File.join(dir, 'app'), File.join(dir, 'lib')]
      end     

      # Run metric fu!
      MetricFu.metrics.each {|metric| MetricFu.report.add(metric) }
      MetricFu.report.save_output(MetricFu.report.to_yaml, MetricFu.base_directory, "report.yml")
      MetricFu.report.save_output(MetricFu.report.to_yaml, MetricFu.data_directory, "#{Time.now.strftime("%Y%m%d")}.yml")

      MetricFu.graphs.each {|graph| MetricFu.graph.add(graph, MetricFu.graph_engine) }
      MetricFu.graph.generate

      MetricFu.report.save_templatized_report
    end

  end
end
