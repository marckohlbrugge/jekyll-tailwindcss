module Jekyll
  module Converters
    class Tailwindcss < Converter
      safe true
      priority :low

      def matches(ext)
        ext =~ /^\.tailwind(css)?$/i
      end

      def output_ext(ext)
        ".css"
      end

      def convert(content)
        dev_mode = Jekyll.env == "development"
        Jekyll.logger.info "Jekyll Tailwind:", "Generating #{!dev_mode && "minified "}CSS"

        system(*Tailwindcss::Commands.compile_command(debug: dev_mode))
      end
    end
  end
end
