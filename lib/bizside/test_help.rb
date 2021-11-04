require 'minitest/reporters'

require_relative 'coverage/launch'
Bizside::CoverageLaunch.load_from_test_helper()

case ENV['CI'].to_s.downcase
when 'jenkins'
  MiniTest::Reporters.use! [
    MiniTest::Reporters::DefaultReporter.new,
    MiniTest::Reporters::JUnitReporter.new
  ]
else
  unless ENV['RM_INFO']
    MiniTest::Reporters.use! [
      MiniTest::Reporters::DefaultReporter.new(color: true)
    ]
  end
end
