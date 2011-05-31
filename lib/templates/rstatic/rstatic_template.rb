require 'fileutils'
require 'syntax/convertors/html'
require 'ruby_static'

class RstaticTemplate < MetricFu::Template

  def write
    # Getting rid of the crap before and after the project name from integrity
    @name = File.basename(Dir.pwd).gsub(/^\w+-|-\w+$/, "")

    report.each_pair do |section, contents|
      if template_exists?(section)
        create_instance_var(section, contents)
        create_instance_var(:per_file_data, per_file_data)
        html = erbify(section)
        fn = output_filename(section)
        MetricFu.report.save_output(html, MetricFu.output_directory, fn)
      end
    end

    write_file_data
  end

  def write_file_data
    convertor = Syntax::Convertors::HTML.for_syntax('ruby')

    per_file_data.each_pair do |file, lines|
      if File.exist?(file)
        data = File.open(file, 'r').readlines
        fn = "#{file.gsub(%r{/}, '_')}.html"

        out = "<h3>#{fn}</h3></br>"
        out << "<div class='code_table'>"
        out << "<table cellpadding='0' cellspacing='0' class='ruby'>"
        data.each_with_index do |line, idx|
          out << "<tr><td valign='top' class='line_number'><small>#{idx + 1}</small></td>"
          out << "<td valign='top' class='score'>"
          if lines.has_key?((idx + 1).to_s)
            out << "<ul>"
            lines[(idx + 1).to_s].each do |problem|
              out << "<li>#{problem[:description]} &raquo; #{RubyComplexity::NAME}</li>"
            end
            out << "</ul>"
          else
            out << "&nbsp;"
          end
          out << "</td>"
          line_for_display = MetricFu.configuration.syntax_highlighting ? convertor.convert(line) : line
          out << "<td valign='top' class='code'><a name='line#{idx + 1}'>#{line_for_display}</a></td>"
          out << "</tr>"
        end
        out << "</table></div>"

        MetricFu.report.save_output(out, MetricFu.output_directory, fn)
      end
    end
  end

  def this_directory
    File.dirname(__FILE__)
  end
end

