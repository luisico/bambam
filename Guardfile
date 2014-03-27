require 'active_support/inflector'

# Switch off notifications
notification :off

guard :rspec, all_after_pass: false, all_on_start: false, cmd: 'foreman run spring rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }

  # Capybara features specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/features/#{m[1]}_spec.rb" }

  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }

  # Factories
  watch(%r{^spec/factories/(.+)\.rb$})                { |m| ["spec/models/#{m[1].singularize}_spec.rb", "spec/controllers/#{m[1]}_controller_spec.rb", "spec/features/#{m[1]}_spec.rb"] }
end

guard :cucumber, all_after_pass: false, all_on_start: false, cli: '--profile guard', bundler: false  do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})                           { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$})      { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
  watch(%r{^features/(.+)/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[2]}.feature")][0] || Dir[File.join("**/*_#{m[2]}.feature")][0] || Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
end