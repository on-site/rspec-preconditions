SimpleCov.start do
  load_profile "test_frameworks"

  track_files "lib/**/*.rb"
  add_filter "lib/rspec/preconditions/version.rb"
end
