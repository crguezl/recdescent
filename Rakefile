require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = Dir.glob("test/tc_unit*.rb").join(" ")
  t.verbose = true
end

task :rstest do
  puts "RSPEC"
  sh "rspec -Ilib test/tc_rspec_lexer.rb"
end

desc "Generate RCov test coverage and open in your browser"
task :coverage do
  require 'rcov'
  sh "rm -fr coverage"
  sh "rcov test/test_*.rb"
  sh "open coverage/index.html"
end


