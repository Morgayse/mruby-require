#!/usr/bin/env ruby
#
# mrbgems test runner
#

if __FILE__ == $0
  repository, dir = 'https://github.com/mruby/mruby.git', 'tmp/mruby'

  build_args = ARGV

  Dir.mkdir 'tmp' unless File.exist?('tmp')
  unless File.exist?(dir)
    system "git clone #{repository} #{dir}"
  end

  builds_correctly = system(%Q[cd "#{dir}"; MRUBY_CONFIG=#{File.expand_path __FILE__} ruby minirake #{build_args.join(' ')}])
  runs_correctly = system(%Q[#{File.join dir, 'bin/mruby'} -e "puts ''"])
  requires_correctly = system(%Q[#{File.join dir, 'bin/mruby'} test/a.rb])
  exit builds_correctly && runs_correctly && requires_correctly
end

MRuby::Build.new do |conf|
  toolchain :gcc
  conf.gembox 'default'

  conf.enable_debug
  conf.enable_bintest
  conf.enable_test

  conf.gem :core => 'mruby-eval'
  conf.gem :core => 'mruby-io'
  conf.gem :git => 'https://github.com/iij/mruby-dir.git'
  conf.gem :git => 'https://github.com/iij/mruby-tempfile.git'

  conf.gem File.expand_path(File.dirname(__FILE__))
end
