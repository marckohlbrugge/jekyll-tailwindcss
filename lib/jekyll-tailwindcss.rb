# frozen_string_literal: true
module Tailwindcss
end
module Jekyll
  module Tailwindcss
  end
end

require "jekyll"
require_relative "tailwindcss/version"
require_relative "tailwindcss/commands"
require_relative "tailwindcss/upstream"
require_relative "jekyll/converters/tailwindcss"
