# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jekyll::Converters::Tailwindcss do
  let(:converter) { described_class.new }

  it "has a version number" do
    expect(Jekyll::Tailwindcss::VERSION).not_to be nil
  end

  describe "#matches" do
    it "matches .tailwindcss files" do
      expect(converter.matches(".tailwindcss")).to be(true)
    end

    it "does not match non-.tailwindcss files" do
      expect(converter.matches(".html")).to be(false)
    end
  end

  describe "#output_ext" do
    it "always outputs the .css file extension" do
      expect(converter.output_ext("some-random-string")).to eql(".css")
    end
  end

  describe "#convert" do
    let(:tailwindcss_content) do
      <<~TAILWINDCSS
        @tailwind base;
        @tailwind components;
        @tailwind utilities;
      TAILWINDCSS
    end
    let(:css_content) { "body { color: red; }" }
    let(:error_message) { nil }

    let(:jekyll_env) { "development" }
    let(:env_options) { { "BROWSERSLIST_IGNORE_OLD_DATA" => "1" } }
    let(:mock_stdin) { instance_double(IO).as_null_object }
    let(:mock_stdout) { instance_double(IO, read: css_content) }
    let(:mock_stderr) { instance_double(IO, read: error_message) }

    let(:compile_command_regex) { /tailwindcss --input - --config \.\/tailwind.config.js$/ }

    before do
      allow(Jekyll).to receive(:env).and_return(jekyll_env)
      allow(Jekyll.logger).to receive(:info)
      allow(Open3).to receive(:popen3).with(env_options, compile_command_regex).and_yield(mock_stdin, mock_stdout, mock_stderr, nil)
    end

    context "using defaults" do
      it "calls the tailwindcss CLI" do
        expect(Jekyll.logger).to receive(:info).with("Jekyll Tailwind:", "Generating CSS")
        expect(Jekyll.logger).not_to receive(:warn)
        expect(mock_stdin).to receive(:write).with(tailwindcss_content)
        expect(mock_stdout).to receive(:read)
        expect(mock_stderr).to receive(:read)

        expect(converter.convert(tailwindcss_content)).to eq(css_content)
      end
    end

    context "when not in development mode" do
      let(:jekyll_env) { "production" }
      let(:compile_command_regex) { /--minify$/ }

      it "includes the --minify option" do
        expect(Jekyll.logger).to receive(:info).with("Jekyll Tailwind:", "Generating minified CSS")
        expect(converter.convert(tailwindcss_content)).to eq(css_content)
      end
    end

    context "when CLI returns an error" do
      let(:error_message) { "Unknown word at Input.error..." }

      it "logs the error, still returns output from stdout" do
        expect(Jekyll.logger).to receive(:warn).with("Jekyll Tailwind:", error_message)
        expect(mock_stdout).to receive(:read)
        expect(mock_stderr).to receive(:read)

        expect(converter.convert(tailwindcss_content)).to eq(css_content)
      end
    end
  end
end
