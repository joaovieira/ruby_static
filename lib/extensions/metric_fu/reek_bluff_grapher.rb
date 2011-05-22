require 'metric_fu'
require 'ruby_static'

class MetricFu::ReekBluffGrapher
  def graph!
    if File.basename(MetricFu.output_directory) == RubyStatic::ANALYSER.underscore
      legend = @reek_count.keys.sort
      data = ""
      legend.each do |name|
        data += "g.data('#{name}', [#{@reek_count[name].join(',')}])\n"
      end
      content = <<-EOS
        var g = new Bluff.Line('#{RubyStatic::NAME}', '550x330');
        g.theme_pastel();
        g.tooltips = true;
        g.hide_title = 'true';
        #{data}
        g.labels = #{@labels.to_json};
        g.draw();
      EOS

      File.open(File.join(MetricFu.output_directory, 'reek.js'), 'w') {|f| f << content }
    end
  end
end
