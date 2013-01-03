require 'rspec/core/formatters/html_formatter'
require 'pathname'
require 'fileutils'

module Watir
  class RSpec
    # Custom RSpec formatter
    # * saves screenshot of the browser upon test failure
    # * saves html of the browser upon test failure
    # * saves all files generated/downloaded during the test and shows them in the report
    class HtmlFormatter < ::RSpec::Core::Formatters::HtmlFormatter
      # @private
      def initialize(output)
        @output_path = File.expand_path(ENV["WATIR_RESULTS_PATH"] || (output.respond_to?(:path) ? output.path : "tmp/spec-results/index.html"))
        FileUtils.rm_rf File.dirname(@output_path), :verbose => true if File.exists?(@output_path)

        @output_relative_path = Pathname.new(@output_path).relative_path_from(Pathname.new(Dir.pwd))
        puts "Results will be saved to #{@output_relative_path}"

        @files_dir = File.dirname(@output_path)
        FileUtils.mkdir_p(@files_dir)
        @files_saved_during_example = []

        super(File.open(@output_path, "w"))
      end

      # @private
      def example_group_started(example_group)
        @files_saved_during_example.clear
        super
      end

      # @private
      def example_started(example)
        @files_saved_during_example.clear
        super
      end

      # @private
      def extra_failure_content(exception)
        browser = example_group.before_all_ivars[:@browser] || $browser
        return super unless browser && browser.exists?

        save_screenshot browser
        save_html browser

        content = []
        content << "<span>"
        @files_saved_during_example.each {|f| content << link_for(f)}
        content << "</span>"
        super + content.join($/)
      end

      # Generate unique file path for the current spec. If the file
      # will be created during that spec and spec fails then it will be
      # shown automatically in the html report.
      #
      # @param [String] file_name File name to be used for file.
      #   Will be used as a part of the complete name.
      # @return [String] Absolute path for the unique file name.
      def file_path(file_name, description=nil)
        extension = File.extname(file_name)
        basename = File.basename(file_name, extension)
        file_path = File.join(@files_dir, "#{basename}_#{::Time.now.strftime("%H%M%S")}_#{example_group_number}_#{example_number}#{extension}")
        @files_saved_during_example.unshift(:desc => description, :path => file_path)
        file_path
      end

      private

      def link_for(file)
        return unless File.exists?(file[:path])

        description = file[:desc] ? file[:desc] : File.extname(file[:path]).upcase[1..-1]
        path = Pathname.new(file[:path])
        "<a href='#{path.relative_path_from(Pathname.new(@output_path).dirname)}'>#{description}</a>&nbsp;"
      end

      def save_html(browser)
        file_name = file_path("browser.html")
        begin
          html = browser.html
          File.open(file_name, 'w') {|f| f.puts html}
        rescue => e
          $stderr.puts "saving of html failed: #{e.message}"
        end
        file_name
      end

      def save_screenshot(browser, description="Screenshot")
        file_name = file_path("screenshot.png", description)
        browser.screenshot.save(file_name)
        file_name
      end

    end
  end
end
