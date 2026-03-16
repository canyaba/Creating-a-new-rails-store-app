require "rubygems"

# Ruby 4 on Windows may install some stdlib gems outside the app bundle.
if Gem.win_platform? && Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("4.0.0")
  {
    "csv" => { lib: true, ext: false },
    "fiddle" => { lib: true, ext: true }
  }.each do |name, paths|
    if paths[:lib]
      lib_path = Dir[File.join(Gem.default_dir, "gems", "#{name}-*", "lib")].sort.last
      $LOAD_PATH.unshift(lib_path) if lib_path && !$LOAD_PATH.include?(lib_path)
    end

    if paths[:ext]
      ext_path = Dir[File.join(Gem.default_dir, "extensions", "**", "#{name}-*")].sort.last
      $LOAD_PATH.unshift(ext_path) if ext_path && !$LOAD_PATH.include?(ext_path)
    end
  end
end

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.
