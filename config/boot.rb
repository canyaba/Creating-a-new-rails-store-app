require "rubygems"

# Ruby 4 on Windows may install fiddle outside the app bundle, but IRB/Reline
# still needs it for `rails console`.
if Gem.win_platform? && Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("4.0.0")
  fiddle_lib = Dir[File.join(Gem.default_dir, "gems", "fiddle-*", "lib")].sort.last
  fiddle_ext = Dir[File.join(Gem.default_dir, "extensions", "**", "fiddle-*")].sort.last

  $LOAD_PATH.unshift(fiddle_lib) if fiddle_lib && !$LOAD_PATH.include?(fiddle_lib)
  $LOAD_PATH.unshift(fiddle_ext) if fiddle_ext && !$LOAD_PATH.include?(fiddle_ext)
end

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.
