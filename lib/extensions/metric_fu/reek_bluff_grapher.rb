class MetricFu::ReekBluffGrapher
  def graph!
    if File.basename(MetricFu.output_directory) == 'ruby_static'
      legend = @reek_count.keys.sort
      data = ""
      legend.each do |name|
        data += "g.data('#{name}', [#{@reek_count[name].join(',')}])\n"
      end
      content = <<-EOS
        var g = new Bluff.Line('Static', '400x240');
        g.theme_pastel();
        g.tooltips = true;
        g.title_font_size = '16px';
        g.legend_font_size = '8px';
        g.marker_font_size = '7px';
        g.hide_title = 'true';
        g.title = 'Reek: code smells';
        #{data}
        g.labels = #{@labels.to_json};
        g.draw();
      EOS

      File.open(File.join(MetricFu.output_directory, 'reek.js'), 'w') {|f| f << content }
    end
  end
end
