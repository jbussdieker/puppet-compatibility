require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send('relative')
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]

task :beaker_all do
  nodes = Dir['spec/acceptance/nodesets/*.yml'].sort!.collect { |node|
    node.slice!('.yml')
    File.basename(node)
  }
  nodes.each do |node|
    puts "############################# #{node} ##############################"
    start_time = Time.now
    pid = fork do
      $stdout.sync = true
      exec("rake beaker PUPPET_VERSION=3.4.3 BEAKER_destroy=yes BEAKER_set=#{node} BEAKER_provision=yes")
    end
    Process.wait
    end_time = Time.now
    puts "### Exit Code: #{$?.exitstatus} Duration: #{end_time - start_time}"
  end
end
